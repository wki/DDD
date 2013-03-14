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

__END__

#### gedachte Benutzung von Aggregaten:

## Möglichkeit 1:
# abrufen von DB, verändern, speichern
# offiziell: repository, sparen wir uns
my $orderlist = $domain->orderlist(id => 42)->load;
$orderlist->mach_was;
$orderlist->save; # might die

# neu Erzeugen, speichern I
# offiziell: factory, sparen wir uns
my $new_order = $domain->orderlist(user => 'Joe', mail => 'joe@doe.de');
$orderlist->mach_was;
$orderlist->save; # might die

# neu Erzeugen, speichern II
my $new_order = $domain->orderlist;
$new_order->mach_was;
$new_order->save; # might die

## Möglichkeit 2:
# abrufen, verändern, speichern
my $orderlist = $domain->orderlist->find(42);
$orderlist->machwas;
$orderlist->save;

# neu erzeugen:
my $new_order = $domain->orderlist->create(user => 'Joe', ...);
$new_order->mach_was;
$new_order->save; # might die


#### gesachte Benutzung von Services:

$domain->service->methode(42);


### Spezial Fall Service "security"

# set user (roles guessed via relation)
$domain->security->user($user);

# User wieder abfragen (DBIC-Row)
my $user = $domain->security->user->id;

# Fähigkeiten abfragen
$domain->security->user_can(...);


