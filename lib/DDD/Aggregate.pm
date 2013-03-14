package DDD::Aggregate;
use Moose;
use Try::Tiny;
use namespace::autoclean;

extends 'DDD::Entity';

=head1 NAME

DDD::Aggregate - base class for an aggregate

=head1 SYNOPSIS

    package My::Aggregate;
    use Moose;
    
    extends 'DDD::Aggregate';
    
    # the resultset to read from, mandatory
    sub resultset_name { 'FooBar' }
    
    # an optional part of the aggregate
    has children => (
        traits  => ['Array'],
        is      => 'rw',
        isa     => 'ArrayRef',
        handles => { ... }
    );
    
    # optionally define if needed:
    sub save_children { ... }
    sub load_children { ... }
    sub init_children { ... }
    sub must_satisfy_children { ... }
    
    # if row needs check:
    sub must_satisfy_row { ... }

=head1 DESCRIPTION

=head1 METHODS

=cut

sub _run_attribute_hooks {
    my ($self, $prefix) = @_;
    
    foreach my $attribute ($self->meta->get_all_attributes) {
        my $method = join '_', $prefix, $attribute->name;
        $self->$method if $self->can($method);
    }
}

before save => sub {
    my $self = shift;
    
    $self->must_satisfy;
};

after save => sub {
    my $self = shift;
    
    $self->_run_attribute_hooks('save');
};

after load => sub {
    my $self = shift;
    
    $self->_run_attribute_hooks('load');
};

after init => sub {
    my $self = shift;
    
    $self->_run_attribute_hooks('init');
};

=head2 must_satisfy

ensure all invariants defined are satisfied or die with a meaningful exception

=cut

sub must_satisfy {
    my $self = shift;
    
    $self->_run_attribute_hooks('must_satisfy');
}

=head2 is_satisfied

returns a boolean based on a check if invariants are satisfied

=cut

sub is_satisfied {
    my $self = shift;
    
    my $is_satisfied = 0;
    try {
        $self->must_satisfy;
        $is_satisfied = 1;
    };
    
    return $is_satisfied;
}

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
1;
