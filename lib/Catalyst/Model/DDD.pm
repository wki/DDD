package Catalyst::Model::DDD;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

extends 'Catalyst::Model::Factory::PerRequest';

=head1 NAME

Catalyst::Model::DDD

=head1 SYNOPSIS

    package MyApp::Model::Domain::Something;
    use Moose;
    extends Catalyst::Model::DDD;
    
    __PACKAGE__->config(
        class             => 'MyApp::Domain::Something',
        schema_from_model => 'DB',
        args              => { optional => 'args' },
    );
    
    1;

=cut

has class => (
    is       => 'ro', 
    isa      => 'Str', 
    required => 1,
);

has schema_from_model => (
    is       => 'ro', 
    isa      => 'Str', 
    required => 1,
);

sub prepare_arguments {
    my ($self, $app, $arg) = @_;

    return {
        schema => $c->model($self->schema_from_model),
        (exists $self->{args} ? %{$self->{args}} : ()),
        %$arg
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
