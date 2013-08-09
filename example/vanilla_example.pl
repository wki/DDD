#!/usr/bin/env perl
use 5.016;
use FindBin;
use lib "$FindBin::Bin/lib",
        "$FindBin::Bin/../../StatisticsCollector/lib";
use Benchmark;
use StatisticsCollector::Schema;
use Vanilla;
# use Path::Class;

say 'starting.';
my $schema = StatisticsCollector::Schema->connect(
    'dbi:Pg:dbname=statistics', 
    'postgres', ''
);

say 'creating Domain.';
my $domain = Vanilla->new(schema => $schema);
say "  domain: $domain, schema: $schema";
say '';

say 'creating Domain again.';
my $domain2 = Vanilla->new(schema => $schema);
say "  domain: $domain2, schema: $schema";
say '';

say 'obtaining some_service';
my $some_service = $domain->some_service;
say "  some_service: $some_service";
$some_service->some_method;
say '';


say 'introspecting subdomain "sales"';
my $sales = $domain->sales;
say "  sales: $sales";
say '';

say 'calling sales->sell_service->sell';
$sales->sell_service->sell;
say '';


# timethese(1_000, {
#     new_domain          => sub { Vanilla->new(schema => $schema) },
#     obtain_sales        => sub { Vanilla->new(schema => $schema)->sales },
#     method_call         => sub { $sales->sell_service->mark_sold },
#     sell_service_method => sub { Vanilla->new(schema => $schema)->sales->sell_service->mark_sold },
# });


say 'about to finish.';

exit;
