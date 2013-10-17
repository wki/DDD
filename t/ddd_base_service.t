use Test::Most;

use ok 'DDD::Base::Service';

{
    package D;
    use Moose;
    extends 'DDD::Base::Domain';
    
    package S;
    use Moose;
    extends 'DDD::Base::Service';
    
    # fake DSL-injected things
    Moose::Util::MetaRole::apply_metaroles(
        for             => 'S',
        class_metaroles => {
            class  => ['DDD::Meta::Role::Class::Subscribe'],
        },
    );

    has diagnostics => (is => 'rw', isa => 'Str', default => '');

    sub do_this {
        my $self = shift;

        $self->diagnostics($self->diagnostics . 'do_this');
    }

    sub _enter_method {
        my ($self, $method) = @_;

        $self->diagnostics($self->diagnostics . "enter:$method");
    }

    sub _leave_method {
        my ($self, $method) = @_;

        $self->diagnostics($self->diagnostics . "leave:$method");
    }
}

note 'callbacks';
{
    my $s = S->new(domain => D->new);

    is $s->diagnostics,
        '',
        'diagnostics empty';

    $s->do_this;
    is $s->diagnostics,
        'enter:do_thisdo_thisleave:do_this',
        'diagnostics filled';
}

done_testing;
