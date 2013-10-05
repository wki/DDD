use strict;
use warnings;
use Test::More;

use ok 'Catalyst::Model::DDD';

my $c = 'c';

note 'construction';
{
    my $ddd = Catalyst::Model::DDD->new(domain_class => 'Foo');
    # is_deeply
    #     $ddd->prepare_arguments( $c, { a => 42, b => sub { 13 } } ),
    #     { a => 42, b => 13 },
    #     'mangle_arguments executes coderef hash values';
}

### TODO: need more tests.

done_testing;
