package DDD::Service;
use Moose;
use namespace::autoclean;

Moose::Exporter->setup_import_methods(
    with_meta => [
        'on',
    ],
    class_metaroles => {
        class  => ['DDD::Meta::Role::Class::Subscribe'],
    },
    also => [
        # with_meta has precedence over 'also' -- see Moose::Exporter
        'Moose'
    ],
);

=head1 NAME

DDD::Service - DSL for Services

=head1 SYNOPSIS

    package MyDomain::Xxx::SomeService;
    use DDD::Service;
    
    # will by set by IoC Container of Domain/Subdomain
    has whatever => (
        is  => 'ro',
        isa => 'Str',
    );
    
    # listen to an event
    on FooChanged => sub {
        my ($self, $event) = @_;
        
        # process event
    };
    
    # a method callable from outside
    sub do_something {
        my ($self, $foo) = @_;
        
        # really do something
    }
    
    1;

=head1 DESCRIPTION

=head1 METHODS

=cut

sub init_meta {
    my $package = shift;
    my %args    = @_;

    Moose->init_meta(%args);

    my $meta = $args{for_class}->meta;
    $meta->superclasses('DDD::Base::Service');
    
    return $meta;
}

=head2 on

=cut

sub on {
    my ($meta, $event_name, $sub) = @_;
    
    # warn "on '$event_name' [meta=$meta]";
    
    # Service Class Metaobject must have the right trait applied
    $meta->subscribe_to($event_name, $sub);
}

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
1;
