package DDD::Base::Domain;
use 5.010;
use Try::Tiny;
use Scalar::Util 'refaddr';
use Moose;

extends 'DDD::Base::Container';
with 'DDD::Role::EventPublisher';

# holds various keys for debugging various areas of things happening.
# valid flags are:
#   build           - construction process
#   subscribe       - subscriptions made to events
#   process         - processing events
#
has _debug => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { +{} },
);

# needed by Catalyst Model to fill hash with proper keys
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

has domain => (
    is    => 'ro',
    isa   => 'DDD::Base::Domain',
    block => sub { $_[1] },
);

# set by prepare: holds values for immediately following request
has _request_values => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { +{} },
);

around BUILDARGS => sub {
    my $orig = shift;
    my $class = shift;
    
    my %args = @_;
    if (exists $args{_debug}) {
        my $debug_options = $args{_debug};
        
        if (!ref $debug_options) {
            $args{_debug} = {
                map { ($_ => 1) } 
                split qr{\s+}xms, $debug_options
            };
        } elsif (ref $debug_options eq 'ARRAY') {
            $args{_debug} = {
                map { ($_ => 1) } 
                @$debug_options
            };
        }
    }
    
    $class->$orig(%args);
};

after BUILD => sub {
    my $self = shift;
    
    my $meta = $self->meta;
    
    $self->autoload($self);
    
    foreach my $a ($meta->get_all_attributes) {
        next if !$a->can('lifecycle');
        my $lifecycle = $a->lifecycle;
        next if !$lifecycle;
        
        next if $lifecycle !~ m{\b Request \b}xms;
        
        $self->log_debug(
            build => "Adding lifecycle: $lifecycle name=${\$a->name}"
        );
        
        $self->_add_request_scoped_attribute(
            {
                object    => $self,
                attribute => $a->name,
                clearer   => $a->clearer,
            },
        );
    }

    $self->log_debug(build => 'finished building domain object');
};

sub log_debug {
    my ($self, $area, $message) = @_;
    
    return if $area && !exists $self->_debug->{$area};
    
    say "DEBUG [$area]: $message";
}

sub instance {
    my ($class, @args) = @_;
    
    state $object = $class->new(@args);
    
    return $object;
}

# prepare per-request attributes into a special hashref for lazy builders
sub prepare {
    my ($self, $values) = @_;
    
    $self->log_debug(build => 'prepare request attributes');
    $self->_request_values($values);
}

# clean per-request attributes
sub cleanup {
    my $self = shift;

    $self->log_debug(build => 'cleanup request attributes');
    
    # stolen from OX::Application
    for my $service_name ($self->get_service_list) {
        my $service = $self->get_service($service_name);
        if ($service->does('DDD::LifeCycle::Request')) {
            # warn "Service '$service_name' is Request-Scoped";
            $service->flush_instance;
        }
    }
    
    # foreach my $a ($self->_all_request_scoped_attributes) {
    #     my $object  = $a->{object};
    #     my $clearer = $a->{clearer};
    #     
    #     use Data::Dumper; $Data::Dumper::Maxdepth = 1; warn Dumper $a;
    #     warn "want to clear $a via method '$clearer'";
    #     
    #     $object->$clearer();
    # }

    # clean up to be sure not to leave secrets of current request
    $self->_request_values({});
}

1;
