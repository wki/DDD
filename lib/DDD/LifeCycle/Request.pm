package DDD::LifeCycle::Request;
use Moose::Role;
use namespace::autoclean;

# stolen from OX
with 'Bread::Board::LifeCycle::Singleton';

1;
