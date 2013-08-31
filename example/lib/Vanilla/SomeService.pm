package Vanilla::SomeService;
use 5.016;
use DDD::Service;

has schema => (
    is  => 'ro',
    isa => 'DBIx::Class::Schema',
);

# event listening
on SomeEventName => sub {
    my ($self, $event) = @_;
    
    warn 'SomeEventName caught.';
};

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
