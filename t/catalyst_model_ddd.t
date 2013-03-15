use strict;
use warnings;
use Test::More;

use ok 'Catalyst::Model::DDD';

my $ddd = Catalyst::Model::DDD->new;
is_deeply
    $ddd->mangle_arguments( { a => 42, b => sub { 13 } } ),
    { a => 42, b => 13 },
    'mangle_arguments executes coderef hash values';

done_testing;
