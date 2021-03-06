package DDD::Factory;
use Moose;
use namespace::autoclean;

extends 'DDD::Base::Object';
with 'DDD::Role::Domain';

sub BUILD {
    my $self = shift;
    
    $self->log_debug(build => "factory ${\ref $self}");
}

=head1 NAME

DDD::Factory - base class for a factory

=head1 SYNOPSIS

    package My::Factory;
    use Moose;
    
    extends 'DDD::Factory';
    
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
