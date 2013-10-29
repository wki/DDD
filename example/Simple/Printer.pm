package Simple::Printer;
use 5.010;
use DDD::Service;

=head1 NAME

Simple::Printer - a simple printer service

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=cut

=head1 ATTRIBUTES

=head2 name

=cut

has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

=head1 METHODS

=cut

=head2 echo ( $text )

prints its name and the text given as argument

=cut

sub echo {
    my ($self, $text) = @_;
    
    say $self->name, ': ', $text;
}

__PACKAGE__->meta->make_immutable;
1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
