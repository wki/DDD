package MyApp::Model::Vanilla2;
use Moose;
use namespace::autoclean;

extends 'Catalyst::Component';

sub BUILD {
    my $self = shift;
    
    warn "Model::Vanilla2::BUILD, PID=$$";
}

sub COMPONENT {
    my ($class, $c, $config) = @_;

    warn "Model::Vanilla2::COMPONENT, PID=$$, c=$c";
    
    return $class->new($config);
}

sub ACCEPT_CONTEXT {
    my ($self, $c) = @_;
    
    warn "Model::Vanilla2::ACCEPT_CONTEXT, PID=$$, c=$c";
}

__PACKAGE__->meta->make_immutable;
1;
