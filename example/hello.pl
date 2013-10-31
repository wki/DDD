#!/usr/bin/env perl
use strict;
use warnings;
use FindBin; 
use lib $FindBin::Bin;
use Hello;

#
# construct Hello domain
# arguments are only honored at first call. All subsequent calls
# will only return the existing singleton object.
#
my $hello = Hello->instance(name => 'hello');

#
# call 'echo' method from 'printer' service
# the service is constructed automatically and gets 'name' from domain.
#
$hello->printer->echo(
    join(' ', @ARGV) || 'no text given on command line'
);
