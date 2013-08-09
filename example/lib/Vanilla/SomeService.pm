package Vanilla::SomeService;
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

sub some_method {
    my $self = shift;
    
    say join ' ',
        '  -->',
        __PACKAGE__,
        "some_method() called",
        "domain=${\$self->domain}",
        "schema=${\$self->schema}";
}

__PACKAGE__->meta->make_immutable;
1;
