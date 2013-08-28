package MyApp::Model::Vanilla2;
use Moose;
use Data::Dumper;
use namespace::autoclean;

extends 'Catalyst::Component';

# possibilities:
# 1) has domain, handles all methods of domain
# 2) COMPONENT creates a domain object, ACCEPT_CONTEXT inside domain

has domain_class => (
    is       => 'ro',
    isa      => 'String',
    required => 1,
);

has domain => (
    is  => 'rw',
    isa => 'Object',
);

# just for testing -- move into config as soon as things work
__PACKAGE__->config( domain_class => 'Vanilla', );

sub BUILD {
    my $self = shift;

    warn "Model::Vanilla2::BUILD, PID=$$";
}

sub COMPONENT {
    my ($class, $c, $args) = @_;

    warn "Model::Vanilla2::COMPONENT, PID=$$, c=$c";
    warn Data::Dumper->Dump([$class->config, $args], ['config', 'args']);

    my $merged_config = $class->merge_config_hashes($class->config, $args);
    my $domain_class = delete $merged_config->{domain_class};
    my $domain = $domain_class->new($merged_config);
    
    ### TODO: add a method for each service into model class
    
    ### TODO: check for instantiation of every Request-Lifecycle service
    ###       and add a destruction at the end of the request
    
    # access service to get it lazily created
    $domain->sales;

    warn 'Domain Services: ' .
        join ', ', 
            map { 
                my $a = $_->associated_attribute;
                my $name = $a->name;
                my $predicate = "has_$name";
                $name . ':' . 
                ($a->has_value($domain) ? 'OK' : 'missing') .
                ($a->has_value($domain) ? ':' . ref $domain->$name : '')
            }
            map { $domain->get_service($_) }
            $domain->get_service_list;

    warn 'Sub Domains: ' .
        join ', ',
            #map { $_->name }
            map { $domain->get_sub_container($_) }
            $domain->get_sub_container_list;

    my $self = $domain_class->new(%$merged_config, domain => $domain);

    $c->meta->add_after_method_modifier(
        finalize => sub {
            $self->cleanup($c);
        }
    );

    return $self;
}

sub cleanup {
    my ($self, $c) = @_;

    warn "Model::Vanilla2::cleanup, PID=$$, c=$c";
    
    warn 'Services: ' .
        join ', ', map { "$_" } $self->domain->get_all_services;

    # TODO: go thru all services and clear 'Request' LifeCycle instances
}

sub ACCEPT_CONTEXT {
    my ( $self, $c ) = @_;

    warn "Model::Vanilla2::ACCEPT_CONTEXT, PID=$$, c=$c";

}

__PACKAGE__->meta->make_immutable;
1;

__END__

# we can only hook the beginning of a request,
# OX does this after the request has finished:

sub _flush_request_services {
    my $self = shift;
 
    for my $service ($self->get_service_list) {
        my $injection = $self->get_service($service);
        if ($injection->does('Bread::Board::LifeCycle::Request')) {
            $injection->flush_instance;
        }
    }
}
