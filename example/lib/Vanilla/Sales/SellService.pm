package Vanilla::Sales::SellService;
use 5.016;
use Moose;
use namespace::autoclean;

has domain => (
    is  => 'ro',
    isa => 'Vanilla',
);

has schema => (
    is  => 'ro',
    isa => 'DBIx::Class::Schema',
);

sub sell {
    my $self = shift;
    
    say join ' ',
        '  -->',
        __PACKAGE__,
        "sell() called",
        "domain=${\$self->domain}",
        "schema=${\$self->schema}";
}

sub mark_sold { 'sold!' }

__PACKAGE__->meta->make_immutable;
1;
