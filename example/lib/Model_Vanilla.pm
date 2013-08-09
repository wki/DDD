# ABSTRACT: sample Catalyst Model
package MaApp::Model::Vanilla;
use Moose;
use namespace::autoclean;
# extends 'Catalyst::Model::Factory::PerRequest'; # per usage
extends 'Catalyst::Model::Adaptor'; # per process -- way faster.

has class => ( is => 'ro', default => 'Vanilla' );
has model => ( is => 'ro', default => 'DB' );

sub prepare_arguments {
    my ($self, $c) = @_;
    
    warn 'Model::Vanilla::prepare_arguments, ',
         "$$, c=$c, class=${\$self->class}, model=${\$self->model}";
    
    return {
        schema => $c->model($self->model)->schema,
    };
}

__PACKAGE__->meta->make_immutable;
1;
