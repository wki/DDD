#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;
use FindBin; 
use lib $FindBin::Bin;
use Basic;

#
# construct Basic domain
#
my $basic = Basic->instance;

#
# access everything using the app service 'keeper'
#
my $keeper = $basic->app->keeper;

#
# use our application service to save a new secret
#
$keeper->keep_secret(psst => 'Hide me');

#
# retrieve the phrase saved
#
say 'Phrase is: ', $keeper->retrieve_phrase('psst');

# nobody knows about our secret. Really? run this and see what happens!
