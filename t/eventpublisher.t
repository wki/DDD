use Test::Most;

use ok 'DDD::Event';
use ok 'DDD::EventPublisher';

{
    package D;
    use Moose;
    extends 'DDD::Base::Domain';
    
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

{
    package F;
    use Moose;
    extends 'DDD::Event';
}

my $x = X->new;
# my $d = D->new;
my $publisher = DDD::EventPublisher->new(domain => D->instance);

note 'basic behavior';
{
    is $publisher->_nr_listeners,
        0,
        'nobody listening';
    is $publisher->_nr_events,
        0,
        'no events in store';
}

note 'add/remove listener';
{
    $publisher->add_listener(E => $x, 'callback');
    
    is_deeply $publisher->_listeners, 
        [
            { target => $x, event => 'E', method => 'callback' },
        ], 
        'x is listening';

    $publisher->add_listener(F => $x, 'another_callback');
    is_deeply $publisher->_listeners, 
        [
            { target => $x, event => 'E', method => 'callback' },
            { target => $x, event => 'F', method => 'another_callback' },
        ], 
        'x is listening twice';
    
    $publisher->remove_listener(F => X->new);
    is_deeply $publisher->_listeners, 
        [
            { target => $x, event => 'E', method => 'callback' },
            { target => $x, event => 'F', method => 'another_callback' },
        ], 
        'nothing removed';
    
    $publisher->remove_listener(F => $x);
    is_deeply $publisher->_listeners, 
        [
            { target => $x, event => 'E', method => 'callback' },
        ], 
        'x is listening once again';
}

note 'event processing';
{
    my $event = E->new;
    is $x->status, '', 'callback method not yet called';
    $publisher->publish($event);
    is $publisher->_nr_events,
        1,
        'one event in store';
    ok $publisher->has_event('E'), 'has event "E"';
    is $x->status, '', 'callback method still not called';
    
    $publisher->process_events;
    is $x->status, $event, 'callback method called';
    
    is $publisher->_nr_events,
        0,
        'store empty';
    ok !$publisher->has_event('E'), 'does not have event "E"';
}

done_testing;
