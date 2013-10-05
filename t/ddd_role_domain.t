use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'DDD::Role::Domain';

{
    package Unguessable;
    use Moose;
    with 'DDD::Role::Domain';
    
    package Xxx;
    use Moose;
    extends 'DDD::Base::Domain';
    
    package Xxx::Guessable;
    use Moose;
    with 'DDD::Role::Domain';
}

note 'domain guess';
{
    my $u = Unguessable->new;
    
    dies_ok { $u->domain }
        'domain guessing fails';
    
    
    my $x = Xxx->instance;
    
    my $g = Xxx::Guessable->new;
    is $g->domain, $x, 'domain guessed right';
}

done_testing;
