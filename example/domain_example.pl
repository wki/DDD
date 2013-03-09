#!/usr/bin/env perl
use 5.016;
use FindBin;
use lib $FindBin::Bin,
        "$FindBin::Bin/../lib",
        "$FindBin::Bin/../../StatisticsCollector/lib";
use DemoDomain;
use StatisticsCollector::Schema;
use Path::Class;

say 'starting.';
my $schema = StatisticsCollector::Schema->connect(
    'dbi:Pg:dbname=statistics', 
    'postgres', ''
);
my $root_dir = dir($FindBin::Bin);

say 'creating DemoDomain.';
my $domain = DemoDomain->new(schema => $schema, root_dir => $root_dir);
say "  domain: $domain";
say '';

say 'calling orderlist Aggregate.';
my $o1 = $domain->_orderlist;
say "  o1: $o1";
my $o2 = $domain->_orderlist;
say "  o2: $o2";
my $o42 = $domain->orderlist(id => 42);
say "  o42: $o42";
say '';

say 'calling file Service.';
my $f1 = $domain->file_service;
say "  f1: $f1";
my $f2 = $domain->file_service;
say "  f2: $f2";

$domain->file_service->list_files;
say '';

say 'about to finish.';

exit;