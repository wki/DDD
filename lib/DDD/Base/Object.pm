package DDD::Base::Object;
use Moose;
use MooseX::Storage;
use DateTime;
use Scalar::Util 'blessed';
# use namespace::autoclean; # interferes with overload.
use overload
    '""' => \&_as_string,
    fallback => 1;

with Storage(format => 'JSON', io => 'File');

MooseX::Storage::Engine->add_custom_type_handler(
    'DateTime' => (
        expand   => sub { DateTime->from_epoch( epoch => shift, time_zone => 'local' ) },
        collapse => sub { shift->epoch },
    )
);
MooseX::Storage::Engine->add_custom_type_handler(
    'Path::Class::File' => (
        expand   => sub { Path::Class::File->new( shift ) },
        collapse => sub { shift->stringify },
    )
);
MooseX::Storage::Engine->add_custom_type_handler(
    'Path::Class::Dir' => (
        expand   => sub { Path::Class::Dir->new( shift ) },
        collapse => sub { shift->stringify },
    ),
);

=head1 NAME

DDD::Base::Object - common base class for most DDD objects

=head1 SYNOPSIS

    # not used directly. Just demonstrates base class behavior
    my $object = DDD::Base::Object->new( ... );
    
    # serialisation
    my $hashref = $object->pack;
    my $new_object = $class->unpack($hashref);
    
    # JSON
    my $json = $object->freeze;
    my $new_object = $class->thaw($json);
    
    # load/store
    $object->store('my_file.json');
    my $new_object = $class->load('my_file.json');
    
    # unified way to get current time (DateTime)
    say $object->_now->hms;
    
    # clone object
    my $clone = $object->clone(attribute => 'other_value');
    
    # stringify
    say 'Object is: ' . $object->as_string;
    say "Object is: $object";
    
    # diff between to identically-typed objects
    if ($object->is_equal($other_version)) { ... }
    say 'changes: ' . $object->diff($new_version_of_object);

=head1 DESCRIPTION

applies MooseX::Storage role to every object magically adding C<pack> and
C<unpack> methods.

=head1 ATTRIBUTES

=cut

=head1 METHODS

=cut

=head2 _now

returns now as a DateTime Object

=cut

sub _now { DateTime->now( time_zone => 'local' ) }

=head2 clone ( \%args | %args )

returns a cloned object with all args overwritten

=cut

sub clone {
    my $self = shift;
    my %args = ref $_[0] eq 'HASH' ? %{$_[0]} : @_;

    $self->meta->clone_object($self, %args);
}

=head2 as_string

returns a stringified variant for this object. Overload if special versions
are wanted.

=cut

# allows overloading "as_string" and still supports stringification
sub _as_string { $_[0]->as_string }

sub as_string {
    my $self = shift;
    
    my $class = ref $self;
    $class =~ s{\A .* ::}{}xms;
    
    my $components = $self->_components;
    # return "[$class: " . join(', ', map { "$_=$components->164
    return "[$class: " . 
        join(', ', map { "$_=$components->{$_}" } sort keys %$components) . 
        ']';
}

=head2 is_equal ( $other_object )

returns a true value if the object is identical to the other object.

=cut

sub is_equal {
    my ($self, $other_object) = @_;
    
    return if ref $self ne ref $other_object;
    
    my $diff = $self->_diff($other_object);
    return scalar @$diff == 0;
}

=head2 diff ( $other_object )

show the difference between an object and a newer version

=cut

sub diff {
    my ($self, $other_object) = @_;
    
    if (ref $self ne ref $other_object) {
        return "$self -> $other_object";
    }
    
    my $diff = $self->_diff($other_object);
    
    return join ', ', @$diff;
}

sub _diff {
    my ($self, $other_object) = @_;
    
    my $components   = $self->_components;
    my $compare_with = $other_object->_components;
    
    my %united_keys = (%$components, %$compare_with);
    
    my @diff;
    foreach my $key (sort keys %united_keys) {
        if (!exists $components->{$key}) {
            push @diff, "$key:''->'$compare_with->{$key}'";
        } elsif (!exists $compare_with->{$key}) {
            push @diff, "$key:'$components->{$key}'->''";
        } elsif ($components->{$key} ne $compare_with->{$key}) {
            push @diff, "$key:'$components->{$key}'->'$compare_with->{$key}'";
        }
    }
    
    return \@diff;
}

sub _components {
    my $self = shift;
    
    my @components;
    foreach my $attribute ($self->meta->get_all_attributes) {
        my $name = $attribute->name;
        next if substr($name,0,1) eq '_';
        next if $attribute->does('MooseX::Storage::Meta::Attribute::Trait::DoNotSerialize');
        
        my $accessor = $attribute->accessor;
        my $value    = $accessor && $self->can($accessor) 
                        ? $self->$accessor 
                    :  $name && $self->can($name)
                        ? $self->$name
                        : "-$name: unknown-";
        
        if (blessed $value && $value->can('as_string')) {
            $value = $value->as_string;
        }
        
        no warnings 'uninitialized';
        push @components, $name, "$value";
    }
    
    return { @components };
}

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

# __PACKAGE__->meta->make_immutable;
1;
