package Demo::Schema::Result::R1;
use base 'DBIx::Class::Core';

__PACKAGE__->table('r1');
__PACKAGE__->add_columns(qw(r1_id name description));
__PACKAGE__->set_primary_key('r1_id');

1;
