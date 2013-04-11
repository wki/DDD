package Catalyst::Model::DDD;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

extends 'Catalyst::Model::Factory::PerRequest';

=head1 NAME

Catalyst::Model::DDD - Base class for domain models

=head1 SYNOPSIS

    package MyApp::Model::Domain;
    use Moose;
    extends 'Catalyst::Model::DDD';
    
    __PACKAGE__->config(
        class => 'MyApp::Domain',
        args  => { 
            log     => sub { shift->log },
            schema  => sub { shift->model('DB') },
            storage => sub { shift->model('FileStorage') },
            is_live => sub { shift->is_live },
        },
    );
    
    1;

=cut

sub prepare_arguments {
    my ($self, $c, $arg) = @_;
    
    my %args = exists $self->{args}
        ? (%{$self->{args}}, %$arg )
        : %$arg;
    
    return {
        # deref code-refs, keep everything else
        map { ref $_ eq 'CODE' ? $_->($c) : $_ }
        %args
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
