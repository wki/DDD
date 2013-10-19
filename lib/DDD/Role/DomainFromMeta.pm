package DDD::Role::DomainFromMeta;
use Moose::Role;

sub domain {
    $_[0]->meta->domain;
}

sub log_debug {
    $_[0]->domain->log_debug(@_[1..$#_]);
}

1;
