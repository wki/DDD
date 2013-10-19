package Demo::Domain::Something;
use Moose;
use namespace::autoclean;

extends 'DDD::Aggregate';

# my $meta = __PACKAGE__->meta;
# my $meta_can_domain = $meta->can('domain') ? 'YES' : 'NO';
# my $domain = $meta->can('domain') ? $meta->domain : '-undef-';
# 
# warn "loaded Something, meta = $meta, can domain = $meta_can_domain, domain = $domain";

__PACKAGE__->meta->make_immutable;
1;
