package Demo::Domain::ShortLived;
use DDD::Service;

sub do_something {
    my $self = shift;
    
    return 42;
}

1;
