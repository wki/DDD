package DDD::Repository;
use Moose;
use namespace::autoclean;

extends 'DDD::Base::Object';
with 'DDD::Role::Domain';

sub BUILD {
    my $self = shift;
    
    $self->log_debug(build => "repository ${\ref $self}");
}

=head1 NAME

DDD::Repository - base class for a repository

=head1 SYNOPSIS

    package My::Repository;
    use Moose;
    
    extends 'DDD::Repository';
    
    # ...

=head1 DESCRIPTION

=head1 METHODS

=cut

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
1;
