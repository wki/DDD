package DDD::Meta::Role::Class::Container;
use Moose::Role;

=head1 NAME

DDD:::Meta::Role::Class::Container - role for Container Class Meta Object

=head1 SYNOPSIS

=head1 DESCRIPTION

a container may consist of services or subdomains. Both need to get
instantiated in order to ensure that event listeners are run.

=head1 ATTRIBUTES

=cut

=head2 autoload_services

contains the names of all services (in terms of Bread::Board) that must get
autoloaded as soon as an object this meta class belongs to is instantiated.

=cut

has autoload_services => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub { [] },
);

=head2 autoload_containers

holds all names for subdomains and application to recursively autoload them
after domain instantiation

=cut

has autoload_containers => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub { [] },
);

=head2 prepare_classes

holds all names for classes that have a modified meta class holding the domain
object

=cut

has prepare_classes => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub { [] },
);

=head1 METHODS

=cut

=head2 autoload_service ( $name )

=cut

sub autoload_service {
    my ($self, $name) = @_;
    
    push @{$self->autoload_services}, $name;
}

=head2 autoload_container ( $name )

=cut

sub autoload_container {
    my ($self, $name) = @_;
    
    push @{$self->autoload_containers}, $name;
}

=head2 prepare_class

=cut

sub prepare_class {
    my ($self, $class) = @_;
    
    push @{$self->prepare_classes}, $class;
}

# # helper: give back the class name this meta object is associated with
# sub _my_class {
#     my $self = shift;
#     
#     my @classes = $self->class_precedence_list;
#     
#     return $classes[0];
# }

1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
