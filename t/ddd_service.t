use strict;
use warnings;
use Test::More;

{
    package S;
    use DDD::Service;

    has some_attribute => (
        is      => 'ro',
        isa     => 'Str',
        default => '',
    );

    on SomeEventName => sub {
        my ($self, $event) = @_;

        $self->some_attribute( $self->some_attribute . 'event' );
    };

    sub some_method {
        my $self = shift;

        $self->some_attribute( $self->some_attribute . 'method' );
    }
}

{
    package D;
    use Moose;
}

note 'service class behavior';
{
    my $meta = S->meta;

    can_ok $meta, 'subscribed_events';

    is scalar @{$meta->subscribed_events},
        1,
        'subscribed to one event';

    is $meta->subscribed_events->[0]->{event},
        'SomeEventName',
        'subscribed to "SomeEventName"';
}

note 'service object behavior';
{
    my $domain = D->new;
    my $s = S->new(domain => $domain);

    can_ok $s, 'some_attribute', 'some_method', 'all_subscribed_events';
    
    my @subscribed_events = $s->all_subscribed_events;
    is scalar @subscribed_events,
        1,
        'subscribed to one event (list)';
    
    my $subscribed_events = $s->all_subscribed_events;
    is scalar @$subscribed_events,
        1,
        'subscribed to one event (scalar)';
    
}

done_testing;
