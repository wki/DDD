package DDD::Base::Domain;
use Moose;
use Bread::Board::Declare;

# can not use Role::Domain here because we are a Bread::Board container
# and 'has' behaves differently here.
has domain => (
    is       => 'ro',
    block    => sub { $_[1] },
    weak_ref => 1,
);

# [ { name, object, clearer }, ... ]
has _request_scoped_attributes => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub { [] },
    handles => {
        _add_request_scoped_attribute    => 'push',
        _all_request_scoped_attributes   => 'elements',
        _nr_of_request_scoped_attributes => 'count',
    },
);

# set by prepare: holds values for immediately following request
has _request_values => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { +{} },
);

after BUILD => sub {
    my $self = shift;
    
    foreach my $a ($self->meta->get_all_attributes) {
        next if !$a->can('lifecycle');
        my $lifecycle = $a->lifecycle;
        next if !$lifecycle;
        next if $lifecycle !~ m{\b Request \b}xms;
        
        warn "Adding lifecycle: $lifecycle name=${\$a->name} [self=$self]";
        
        $self->_add_request_scoped_attribute(
            {
                object    => $self,
                attribute => $a->name,
                clearer   => $a->clearer,
            },
        );
    }
};

# prepare per-request attributes into a special hashref for lazy builders
sub prepare {
    my ($self, $values) = @_;
    
    $self->_request_values($values);
}

# clean per-request attributes
sub cleanup {
    my $self = shift;

    warn "about to cleanup request-scoped things (${\$self->_nr_of_request_scoped_attributes})";

    foreach my $a ($self->_all_request_scoped_attributes) {
        my $object  = $a->{object};
        my $clearer = $a->{clearer};
        
        $object->$clearer();
    }
}

1;
