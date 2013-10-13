package Demo::Domain::TestService;
use DDD::Service;
use aliased 'Demo::Domain::SomethingHappened';

has schema  => (is => 'ro', isa => 'Object');
has storage => (is => 'ro', isa => 'Object');

has message => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
);

on SomethingHappened => sub {
    my $self = shift;
    
    $self->message($self->message . 'callback');
};

sub test_method {
    my $self = shift;
    
    $self->message($self->message . 'method');
}

sub publishing_method {
    my $self = shift;
    
    $self->message($self->message . 'pub');
    
    $self->publish(SomethingHappened->new(thing => 'xxx'));
    
    $self->message($self->message . 'lish');
}

1;
