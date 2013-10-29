#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;
use FindBin;
use lib $FindBin::Bin, "$FindBin::Bin/../lib";
use Basic;

# construct Basic domain
my $basic = Basic->instance();

# create a new secret and save it
my $secret = $basic->secret_generator(pssst => 'Hide me');
$basic->all_secrets->save($secret);

# try to retrieve secrets
foreach my $key (qw(sesame psst)) {
    my $s = $basic->all_secrets->by_key($key);
    say "Secret of '$key' = " . ($s ? $s->word : '-unknown-');
}

__END__

Idea for Basic Domain:

 - save a word under a "secret" key
 - Subdomain: Vault
   Repository "AllSecrets" -- saves/loads Secret into RAM
   Aggregate "Secret"      -- contains word (Str)
   Factory "SecretCreator" -- constructs a Secret