package MyApp::Model::Vanilla;
use Moose;
use namespace::autoclean;

extends 'Catalyst::Model::DDD';

__PACKAGE__->config(
    domain_class => 'Vanilla',
    log          => sub { MyApp->log },
    user         => sub { MyApp->user },
);

1;
