package My::Service;
use 5.016;
use Moose;
use Path::Class;
use namespace::autoclean;

extends 'DDD::Service';
with 'Role::Jabber',
     'DDD::Role::DBIC::Schema';

has root_dir => (
    is => 'ro',
    isa => 'Path::Class::Dir',
    required => 1,
);

sub list_files {
    my $self = shift;;
    
    say "    file: ", $_->basename
        for grep { !$_->is_dir } $self->root_dir->children;
}



__PACKAGE__->meta->make_immutable;
1;
