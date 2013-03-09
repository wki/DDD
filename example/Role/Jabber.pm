package Role::Jabber;
use 5.016;
use Moose::Role;

sub BUILD {
    my $self = shift;
    
    say ref $self, ' has been built', (@_ ? join(' ', ' - Args:', %{$_[0]}) : ());
}

1;
