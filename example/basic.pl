#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;
use FindBin; use lib $FindBin::Bin;
use Basic;

#
# construct Basic domain
#
my $basic = Basic->instance(_debug => 'build process subscribe');

#
# use our application service to save a new secret
#
$basic->app->keeper->keep_secret(psst => 'Hide me');

#
# retrieve the phrase saved
#
say 'Phrase is: ', $basic->app->keeper->retrieve_phrase('psst');



__END__

Idea for Basic Domain:

 - save a word under a "secret" key
 - Subdomain: Vault
   Repository "AllSecrets" -- saves/loads Secret into RAM
   Aggregate "Secret"      -- contains word (Str)
   Factory "SecretCreator" -- constructs a Secret
   Event 
 - Subdomain: Spy
   Service 'Watcher'

