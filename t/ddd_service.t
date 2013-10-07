use strict;
use warnings;
use DDD::EventPublisher;
use Test::More;
use Test::Exception;

use FindBin;
use lib "$FindBin::Bin/lib";

{
    package D;
    use Moose;
}

use ok 'Demo::Domain::TestService';

note 'service class behavior';
{
    my $meta = Demo::Domain::TestService->meta;

    can_ok $meta, 'subscribed_events';

    is scalar @{$meta->subscribed_events},
        1,
        'subscribed to one event';

    is $meta->subscribed_events->[0]->{event},
        'SomethingHappened',
        'subscribed to "SomethingHappend"';
}

note 'service object behavior w/o publisher';
{
    my $domain = D->new;
    my $s = Demo::Domain::TestService->new(domain => $domain);

    can_ok $s, 'message', 'test_method', 'publishing_method', 'all_subscribed_events';
    
    my @subscribed_events = $s->all_subscribed_events;
    is scalar @subscribed_events,
        1,
        'subscribed to one event (list)';
    
    my $subscribed_events = $s->all_subscribed_events;
    is scalar @$subscribed_events,
        1,
        'subscribed to one event (scalar)';
    
    $s->test_method;
    is $s->message,
        'method',
        'test_method called';
    
    # as we now auto-create a publisher, this test fails.
    # dies_ok { $s->publishing_method }
    #     'calling a publishing method w/o publisher dies';
    
    # instead, we have a similar behavior as below:
    $s->publishing_method;
    is $s->message,
        'methodpublish',
        'successfully published';
}

note 'service object behavior w/ publisher';
{
    my $p = DDD::EventPublisher->new;
    my $domain = D->new;
    my $s = Demo::Domain::TestService->new(
        domain => $domain, 
        event_publisher => $p,
    );
    
    is $s->message,
        '',
        'message empty';
    
    $s->publishing_method;
    is $s->message,
        'publishcallback',
        'successfully published and subscribed';
}

done_testing;
