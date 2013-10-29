#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib $FindBin::Bin, "$FindBin::Bin/../lib";
use Simple;

# construct Simple domain
# arguments are only honored at first call. All subsequent calls
# will only return the existing singleton object.
my $simple = Simple->instance(name => $ARGV[0] // 'simple');

# call 'echo' method from 'printer' service
# the service is constructed automatically and gets 'name' from domain.
$simple->printer->echo(
    join(' ', @ARGV[1..$#ARGV]) // 'no text given on command line'
);
