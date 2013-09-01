use strict;
use warnings;
use Test::More;

use ok 'DDD::EventPublisher';

{
    package X;
    use Moose;
    
    has status => (
        is      => 'rw',
        isa     => 'Any',
        default => '',
    );
    
    sub callback {
        my ($self, $event) = @_;
        
        $self->status($event);
    }
}

{
    package E;
    use Moose;
    extends 'DDD::Event';
}

my $x = X->new;

my $publisher = DDD::EventPublisher->new;

is_deeply $publisher->_listeners,
    [], 
    'nobody listening';
    
$publisher->add_listener(E => $x, 'callback');

is_deeply $publisher->_listeners, 
    [
        {target => $x, event => 'E', method => 'callback'},
    ], 
    'x is listening';

my $event = E->new;
is $x->status, '', 'callback method not yet called';
$publisher->publish($event);
is $x->status, $event, 'callback method called';

done_testing;
