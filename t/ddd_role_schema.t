use strict;
use warnings;
use Test::More;
use Test::Exception;

use FindBin;
use lib "$FindBin::Bin/lib";
use Demo::Schema;

use ok 'DDD::Role::DBIC::Schema';

{
    package S;
    use Moose;
    with 'DDD::Role::DBIC::Schema';
}

dies_ok { S->new } 'new w/o schema dies';
dies_ok { S->new(schema => 42) } 'new w/ illegal schema dies';

my $schema = Demo::Schema->connect;
lives_ok { S->new(schema => $schema) } 'new w/ legal schema lives';

done_testing;
