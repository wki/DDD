use Test::Most;
use FindBin;
use lib "$FindBin::Bin/lib";

{
    package D;
    use Moose;
    extends 'DDD::Base::Domain';
}

use ok 'Demo::Domain::SimpleService';

note 'service class behavior';
{
    my $meta = Demo::Domain::SimpleService->meta;

    can_ok $meta, 'subscribed_events';

    is scalar @{$meta->subscribed_events},
        0,
        'subscribed to no event';
}

note 'service object behavior';
{
    my $s = Demo::Domain::SimpleService->new(domain => D->instance);

    can_ok $s, 'simple_method', 'all_subscribed_events';
    
    my @subscribed_events = $s->all_subscribed_events;
    is scalar @subscribed_events,
        0,
        'subscribed to no event (list)';
    
    my $subscribed_events = $s->all_subscribed_events;
    is scalar @$subscribed_events,
        0,
        'subscribed to no event (scalar)';
    
    is $s->message, '', 'message empty';
    
    $s->simple_method();
    
    is $s->message, 'method', 'method call successful';
}

done_testing;
