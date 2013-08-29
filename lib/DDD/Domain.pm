package DDD::Domain;
use Moose ();
use Moose::Exporter;
use Carp;
use Sub::Install;
use Bread::Board::Declare ();
use Bread::Board::ConstructorInjection (); # be save it is loaded.

Moose::Exporter->setup_import_methods(
    with_meta => [
        'attr', 
        # 'aggregate',
        'service', 'subdomain', 'factory', 'repository'
    ],
    also      => [
        'Moose', 'Bread::Board::Declare'
    ],
);

sub init_meta {
    my $package = shift;
    my %args    = @_;

    Moose->init_meta(%args);

    my $meta = $args{for_class}->meta;
    $meta->superclasses('DDD::Domain::Super');

    return $meta;
}

# exported sub
sub attr {
    my ($meta, $name, %args) = @_;

    # this method is curried (!)
    my $package = caller(1);

    # _resolve_isa_classes($package, \%args);

    warn "Add attr '$package\::$name' [meta=$meta]";

    # TODO: check lifecycle and add to 'Request' scope List
    if (exists $args{lifecycle} && $args{lifecycle} =~ m{\bRequest\b}xms) {
        $args{clearer}   = "_clear_$name";
    }

    if (!exists $args{dependencies} || ref $args{dependencies} eq 'ARRAY') {
        push @{$args{dependencies}}, 'domain';
    } else {
        $args{dependencies}->{domain} = Bread::Board::Declare::dep('/domain');
    }

    Moose::has(
        $meta, $name,
        is => 'ro',
        %args,
    );
}

# # exported sub
# sub aggregate {
#     my ($meta, $name, %args) = @_;
# 
#     # this method is curried (!)
#     my $package = caller(1);
# 
#     _resolve_isa_classes($package, \%args);
# 
#     # _name attribute as a service
#     #   with extra domain dependency and optional id and row parameters
#     push @{$args{dependencies}}, 'domain';
#     $args{parameters}->{id}  = { isa => 'Str', optional => 1 };
#     $args{parameters}->{row} = { isa => 'DBIx::Class::Row', optional => 1 };
#     Moose::has($meta, "_$name", is => 'ro', %args);
# 
#     # name method as accessor
#     Sub::Install::install_sub({
#         code => sub {
#             my $self = shift;
# 
#             return $self->resolve(
#                 service    => "_$name",
#                 parameters => ref $_[0] eq 'HASH'
#                     ? $_[0]
#                     : { @_ },
#             );
#         },
#         into => $package,
#         as   => $name
#     });
# }

sub factory { goto \&service }

sub repository { goto \&service }

sub subdomain {
    # TODO: does loading the isa-class make sense?
    # TODO: does prefixing the $name with $package make sense?
    
    goto \&service;
}

# exported sub
sub service {
    my ($meta, $name, %args) = @_;

    # this method is curried (!)
    my $package = caller(1);

    _resolve_isa_classes($package, \%args);

    warn "Add service '$package\::$name' [meta=$meta]";

    # name attribute as a service
    if (!exists $args{dependencies} || ref $args{dependencies} eq 'ARRAY') {
        push @{$args{dependencies}}, 'domain';
    } else {
        $args{dependencies}->{domain} = Bread::Board::Declare::dep('/domain');
    }

    my $class = $args{isa}
        or croak "Service '$name': isa is missing";

    my $builder = sub {
        my $self = shift;

        my $service = $class->new(name => $name);
        $self->add_sub_container($service);

        return $service;
    };

    Moose::has(
        $meta, $name,
        is        => 'ro',
        lifecycle => 'Singleton',
        default   => $builder,
        lazy      => 1,
        %args,
    );
}

sub _resolve_isa_classes {
    my ($package, $args) = @_;

    # return if !exists $args->{isa};
    # $args->{isa} =~ s{\A [+]}{}xms and return;
    # $args->{isa} = "$package\::$args->{isa}";
}

package DDD::Domain::Super;
use Moose;
use Bread::Board::Declare;

has domain => (
    is       => 'ro',
    block    => sub { $_[1] },
    weak_ref => 1,
);

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

after BUILD => sub {
    my $self = shift;
    
    foreach my $a ($self->meta->get_all_attributes) {
        next if !$a->can('lifecycle');
        my $lifecycle = $a->lifecycle;
        next if !$lifecycle;
        next if $lifecycle !~ m{\b Request \b}xms;
        
        warn "Adding lifecycle: $lifecycle";
        
        $self->_add_request_scoped_attribute(
            {
                object    => $self,
                attribute => $a->name,
                clearer   => $a->clearer,
            },
        );
    }
};

sub cleanup {
    my $self = shift;

    warn "about to cleanup request-scoped things (${\$self->_nr_of_request_scoped_attributes})";

    foreach my $a ($self->_all_request_scoped_attributes) {
        my $object  = $a->{object};
        my $clearer = $a->{clearer};
        
        $object->$clearer();
    }
}

# package DDD::Trait::RequestScope;
# use Moose::Role;
#
# Moose::Util::meta_attribute_alias('RequestScope');
#
# after install_accessors => sub {
#     my $self = shift;
#
#     warn "after install accessors self=$self";
# };

1;
