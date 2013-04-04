use strict;
use warnings;
use Test::More;
use Test::Exception;

use FindBin;
use lib "$FindBin::Bin/lib";
use Demo::Schema;

use ok 'DDD::Role::DBIC::Schema';
use ok 'DDD::Role::DBIC::Result';

{
    package R;
    use Moose;
    
    sub _resultset_name { 'R1' }

    has _handles => (is => 'rw', default => '');
    has id       => (is => 'rw');
    
    with 'DDD::Role::DBIC::Schema';
    with 'DDD::Role::DBIC::Result';
}

my $schema = Demo::Schema->connect;

my $r = R->new(schema => $schema);
ok !$r->can('r1_id'),       'empty: r1_id not exported';
ok !$r->can('name'),        'empty: name not exported';
ok !$r->can('description'), 'empty: description not exported';

$r = R->new(schema => $schema, _handles => ':primary');
ok !$r->can('r1_id'),       ':primary w/o reset: r1_id not exported';
ok !$r->can('name'),        ':primary w/o reset: name not exported';
ok !$r->can('description'), ':primary w/o reset: description not exported';

R->meta->remove_method('__is_initialized__');
$r = R->new(schema => $schema, _handles => ':primary');
ok  $r->can('r1_id'),       ':primary w/ reset: r1_id is exported';
ok !$r->can('name'),        ':primary w/ reset: name not exported';
ok !$r->can('description'), ':primary w/ reset: description not exported';

R->meta->remove_method('__is_initialized__');
R->meta->remove_method('r1_id');
$r = R->new(schema => $schema, _handles => ':columns');
ok !$r->can('r1_id'),       ':columns w/ reset: r1_id is not exported';
ok  $r->can('name'),        ':columns w/ reset: name is exported';
ok  $r->can('description'), ':columns w/ reset: description is exported';

# TODO: check :relations, :methods, :all,

done_testing;
