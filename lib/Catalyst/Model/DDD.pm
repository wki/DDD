package Catalyst::Model::DDD;
use Moose;
use Module::Load;
use namespace::autoclean;

extends 'Catalyst::Component';

=head1 NAME

Catalyst::Model::DDD - Base class for domain models

=head1 SYNOPSIS

define a model like this:

    package MyApp::Model::Domain;
    use Moose;
    extends 'Catalyst::Model::DDD';

    __PACKAGE__->config(
        domain_class => 'MyApp::Domain',

        # more args needed for instantiating domain:
        # FIXME: how do we access catalyst-app related things?
        log          => sub { MyApp->log },
        schema       => sub { MyApp->model('DB') },
        storage      => sub { MyApp->model('FileStorage') },
        is_live      => sub { MyApp->is_live },
    );

    1;

use your model as usual:

    package MyApp::Controller::Xxx;

    sub some_method :Local :Args(0) {
        my ($self, $c) = @_;

        $c->model('Domain')->subdomain->service->do_something('foo');
    }

=cut


# mandatory, must be defined via config
has domain_class => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

# the domain object returned to our caller
# regardless if the domain is a singleton or not, this object is kept
# during the lifetime of the Catalyst app.
has domain => (
    is  => 'ro',
    isa => 'DDD::Base::Domain',
);

# per_request_config settings based on lifecycle 'Request' things of Domain
has per_request_config => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { +{} },
);

# sub BUILD {
#     my $self = shift;
#
#     # will fire early at app construction.
# }

sub COMPONENT {
    my ($class, $c, $args) = @_;
    
    my $merged_config = $class->merge_config_hashes($class->config, $args);

    my $domain_class = delete $merged_config->{domain_class};
    load $domain_class;

    my $domain = $domain_class->instance(%{_resolve_code_refs($merged_config)});

    # ensure we do not initially have per-request things.
    # must be removed, because only the domain knows what is per-request.
    $domain->cleanup;

    # there is no official hook for a component, therefore we need this.
    $c->meta->add_after_method_modifier(
        finalize => sub {
            $domain->cleanup;
        }
    );

    my %per_request_config = (
        map { ($_ => $merged_config->{$_}) }
        map { $_->{attribute} }
        $domain->_all_request_scoped_attributes
    );

    # we return our class here. for each request, we will get called
    # ACCEPT_CONTEXT, which will then return the domain after having
    # initialized the per-request attributes
    my $self = $class->new(
        domain_class       => $domain_class,
        domain             => $domain,
        per_request_config => \%per_request_config,
    );

    return $self;
}

# called for every request.
sub ACCEPT_CONTEXT {
    my $self = shift;
    my $c    = shift;

    my $resolved_per_request_config = _resolve_code_refs($self->per_request_config);
    $self->domain->prepare($resolved_per_request_config);

    return $self->domain;
}

sub _resolve_code_refs {
    my $config = shift;

    return {
        map {
            my $value = $config->{$_};
            ($_ => ref $value eq 'CODE' ? $value->() : $value)
        }
        keys %$config
    };
}

__PACKAGE__->meta->make_immutable;
1;

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
