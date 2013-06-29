# ABSTRACT: a simple domain using Bread::Board::Declare only
package Vanilla;
use 5.016;
use Moose;
use Bread::Board::Declare;
use Vanilla::Sales;
use namespace::autoclean;

# needed to allow subdomains and other things to get this value
has domain => (
    is      => 'ro',
    isa     => 'Vanilla',
    default => sub { shift },
);

# a regular Moose attribute
has schema => (
    is  => 'ro',
    isa => 'DBIx::Class::Schema',
);

# TODO: has storage


### a sample service
has some_service => (
    is           => 'ro',
    isa          => 'Vanilla::SomeService',
    dependencies => {
        domain => dep('/domain'),    # also possible here: 'domain'
        schema => 'schema',
    },
);

### a subdomain. 
### If somebody depends on this subdomain, it must be build earlier.
has sales => (
    is         => 'ro',
    isa        => 'Vanilla::Sales',
    lifecycle  => 'Singleton',
    lazy_build => 1,
);

sub _build_sales {
    my $self = shift;

    $self->add_sub_container( Vanilla::Sales->new(name => 'sales') );
}

__PACKAGE__->meta->make_immutable;
1;
