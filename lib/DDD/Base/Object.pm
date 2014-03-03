package DDD::Base::Object;
use Moose;
use MooseX::Storage;
use DateTime;
use Scalar::Util 'blessed';
# use namespace::autoclean;
# use overload
#     '""' => \&_as_string,
#     fallback => 1;

with Storage(format => 'JSON', io => 'File');

MooseX::Storage::Engine->add_custom_type_handler(
    'DateTime' => (
        expand   => sub { DateTime->from_epoch( epoch => shift, time_zone => 'local' ) },
        collapse => sub { shift->epoch },
    )
);
MooseX::Storage::Engine->add_custom_type_handler(
    'Path::Class::File' => (
        expand   => sub { Path::Class::File->new( shift ) },
        collapse => sub { shift->stringify },
    )
);
MooseX::Storage::Engine->add_custom_type_handler(
    'Path::Class::Dir' => (
        expand   => sub { Path::Class::Dir->new( shift ) },
        collapse => sub { shift->stringify },
    ),
);

=head1 NAME

DDD::Base::Object - common base class for most DDD objects

=head1 SYNOPSIS

=head1 DESCRIPTION

applies MooseX::Storage role to every object magically adding C<pack> and
C<unpack> methods.

=head1 ATTRIBUTES

=cut

=head1 METHODS

=cut

=head2 _now

returns now as a DateTime Object

=cut

sub _now { DateTime->now( time_zone => 'local' ) }

=head2 clone ( \%args | %args )

returns a cloned object with all args overwritten

=cut

sub clone {
    my $self = shift;
    my %args = ref $_[0] eq 'HASH' ? %{$_[0]} : @_;

    $self->meta->clone_object($self, %args);
}

=head2 as_string

returns a stringified variant for this object. Overload if special versions
are wanted.

=cut

sub as_string {
    my $self = shift;
    
    # return "$self" if !$self->can('pack');
    my $data = $self->pack;
    
    join ', ',
        map { "$_: " . (blessed($data->{$_}) && $data->{$_}->can('as_string') ? $data->{$_}->as_string : "$data->{$_}") }
        grep { !m{\A _}xms }
        keys %$data;
}

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

# __PACKAGE__->meta->make_immutable;
1;
