use Test::Most;

use ok 'DDD::Container';

note 'exports';
{
    can_ok 'main',
        qw(has service subdomain factory repository aggregate);
}

note '_camelize';
{
    my @testcases = (
        [ test => 'Test' ],
        [ test_me => 'TestMe' ],
        [ test_me_again => 'TestMeAgain' ],
    );
    
    foreach my $testcase (@testcases) {
        my ($lc, $camelized) = @$testcase;
        is DDD::Container::_camelize($lc), $camelized, "camelize $lc";
    }
}

# TODO: test lifecycle

done_testing;
