package Demo::Domain::SimpleService;
use DDD::Service;

has message => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
);

sub simple_method {
    my $self = shift;
    
    $self->message($self->message . 'method');
}

1;
