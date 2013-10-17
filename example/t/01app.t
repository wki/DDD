#!/usr/bin/env perl
use strict;
use warnings;
use Test::Most;

use Catalyst::Test 'MyApp';

ok( request('/')->is_success, 'Request should succeed' );

done_testing();
