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
            log     => MyApp->log,                  # always the same
            schema  => sub { MyApp->model('DB') },  # maybe per request?
            storage => MyApp->model('FileStorage'), # always the same
            is_live => MyApp->is_live,              # must be class method
        },
    );
    
    1;

=cut

sub mangle_arguments {
    my ($self, $args) = @_;
    
    return {
        # deref code-refs, keep everything else
        map { ref $_ eq 'CODE' ? $_->() : $_ }
        %$args
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
