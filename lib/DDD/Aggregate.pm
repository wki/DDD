package DDD::Aggregate;
use DDD::Meta::Trait::Class::Domain;
use Moose -traits => 'HasDomain';
use Try::Tiny;
use namespace::autoclean;

extends 'DDD::Entity';
with 'DDD::Role::DomainFromMeta';

=head1 NAME

DDD::Aggregate - base class for an aggregate

=head1 SYNOPSIS

    # specify an aggregate inside your Domain/Subdomain
    package My;
    use DDD::Domain;
    
    # isa defaults to My:: followed by the camelized name
    aggregate 'all_things';
    
    
    # your Aggregate
    package My::AllThings;
    use Moose;
    
    extends 'DDD::Aggregate';
    
    # define load and save methods you need

=head1 DESCRIPTION

=head1 METHODS

=cut

# sub _run_attribute_hooks {
#     my ($self, $prefix) = @_;
#     
#     foreach my $attribute ($self->meta->get_all_attributes) {
#         my $method = join '_', $prefix, $attribute->name;
#         $self->$method if $self->can($method);
#     }
# }

# before save => sub {
#     my $self = shift;
#     
#     $self->must_satisfy;
# };
# 
# after save => sub {
#     my $self = shift;
#     
#     $self->_run_attribute_hooks('save');
# };
# 
# after load => sub {
#     my $self = shift;
#     
#     $self->_run_attribute_hooks('load');
# };
# 
# after init => sub {
#     my $self = shift;
#     
#     $self->_run_attribute_hooks('init');
# };

# =head2 must_satisfy
# 
# ensure all invariants defined are satisfied or die with a meaningful exception
# 
# =cut
# 
# sub must_satisfy {
#     my $self = shift;
#     
#     $self->_run_attribute_hooks('must_satisfy');
# }
# 
# =head2 is_satisfied
# 
# returns a boolean based on a check if invariants are satisfied
# 
# =cut
# 
# sub is_satisfied {
#     my $self = shift;
#     
#     my $is_satisfied = 0;
#     try {
#         $self->must_satisfy;
#         $is_satisfied = 1;
#     };
#     
#     return $is_satisfied;
# }

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
1;
