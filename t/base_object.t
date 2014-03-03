use DateTime;
use Path::Class;
use JSON;
use Test::Most;
use Test::MockDateTime;

use ok 'DDD::Base::Object';

# sample class inheriting base
{
    package X;
    use Moose;
    our $VERSION = 23;
    
    extends 'DDD::Base::Object';
    
    has foo  => (is => 'rw', isa => 'Str');
    has bar  => (is => 'rw', isa => 'DateTime');
    has hide => (traits => ['DoNotSerialize'], is => 'rw', isa => 'Str');
}

# sample more complex class
{
    package Y;
    use Moose;
    
    extends 'DDD::Base::Object';
    
    has thing => (is => 'rw', isa => 'X');
    has name  => (is => 'rw', isa => 'Str');
}

note 'serialization';
{
    my $x1 = X->new(foo => 'x42', bar => DateTime->from_epoch(epoch => 1381166265));
    
    is_deeply $x1->pack(),
        { __CLASS__ => 'X-23', foo => 'x42', bar => 1381166265 },
        'pack';
    
    my $x2 = X->unpack( { __CLASS__ => 'X', foo => 'bar', bar => 1381166265 } );
    isa_ok $x2, 'X';
    is $x2->foo, 'bar', 'unpack: foo is bar';
    is $x2->bar->epoch, 1381166265, 'unpack: bar is back';
    
    ### TODO: add tests for Path::Class::  File / Dir
}

note 'store and load';
{
    my $x1 = X->new(foo => 'baz');
    my $dir = Path::Class::tempdir(CLEANUP => 1);
    my $file = $dir->file('bar.json');
    
    ok !-f $file, 'json file not yet present';
    $x1->store($file->stringify);
    ok -f $file, 'json file created';
    
    is_deeply decode_json(scalar $file->slurp),
        { __CLASS__ => 'X-23', foo => 'baz' },
        'JSON file contains serialized object';
    
    my $x2 = X->load($file->stringify);
    isa_ok $x2, 'X';
    is $x2->foo, 'baz', 'unpack: foo is baz';
}

note 'now';
on '2012-12-24 17:23:45' => sub {
    my $x = X->new;
    
    is $x->_now->ymd, '2012-12-24', '_now date';
    is $x->_now->hms, '17:23:45',   '_now time';
};

note 'clone';
{
    # 1381166265 == 2013-10-07 19:17:45
    my $orig = X->new(foo => 'Foo', bar => DateTime->from_epoch(epoch => 1381166265));
    
    my $clone = $orig->clone(foo => 'Bar');
    
    isnt $orig, $clone, 'clone object';
    
    is $orig->foo, 'Foo', 'orig->foo';
    is $clone->foo, 'Bar', 'clone->foo';
    
    is $orig->bar->epoch, 1381166265, 'orig->bar';
    is $clone->bar->epoch, 1381166265, 'clone->bar';
}

note 'stringification';
{
    # 1381166265 == 2013-10-07 19:17:45
    my $x = X->new(foo => 'ffo', bar => DateTime->from_epoch(epoch => 1381166265, time_zone => 'local'), hide => 'hidden');
    my $y = Y->new(thing => $x, name => 'moniker');
    
    is $x->as_string,
        '[X: bar=2013-10-07T19:17:45, foo=ffo]', 
        'X as string';
        
    is $y->as_string,
        '[Y: name=moniker, thing=[X: bar=2013-10-07T19:17:45, foo=ffo]]',
        'Y as string';
}

note 'difference';
{
    # 1381166265 == 2013-10-07 19:17:45
    # 1381186265 == 2013-10-08 00:51:05
    my $x1 = X->new(foo => 'ffo', bar => DateTime->from_epoch(epoch => 1381166265, time_zone => 'local'), hide => 'hidden');
    my $x2 = X->new(foo => 'ffo', bar => DateTime->from_epoch(epoch => 1381166265, time_zone => 'local'), hide => 'xxx');
    
    is $x1->diff($x2), '', 'no difference';
    
    $x2->foo('woodoo');
    is $x1->diff($x2), q{foo:'ffo'->'woodoo'}, 'one field different';
    
    $x2->bar(DateTime->from_epoch(epoch => 1381186265, time_zone => 'local'));
    is $x1->diff($x2), q{bar:'2013-10-07T19:17:45'->'2013-10-08T00:51:05', foo:'ffo'->'woodoo'}, 'two fields different';
}


done_testing;
