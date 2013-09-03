use strict;
use warnings;
use Test::More;

use ok 'DDD::Event';
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

is $publisher->_nr_listeners,
    0,
    'nobody listening';
is $publisher->_nr_events,
    0,
    'no events in store';


$publisher->add_listener(E => $x, 'callback');

is_deeply $publisher->_listeners, 
    [
        { target => $x, event => 'E', method => 'callback' },
    ], 
    'x is listening';


my $event = E->new;
is $x->status, '', 'callback method not yet called';
$publisher->publish($event);
is $publisher->_nr_events,
    1,
    'one event in store';
is $x->status, '', 'callback method still not called';

$publisher->process_events;
is $x->status, $event, 'callback method called';

is $publisher->_nr_events,
    0,
    'store empty';


done_testing;
