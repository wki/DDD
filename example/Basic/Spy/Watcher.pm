package Basic::Spy::Watcher;
use DDD::Service;

=head1 NAME

Basic::Spy::Watcher - a watcher service

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 EVENTS

=cut

=head2 SecretChanged

observe a secret change and reveil what we received

=cut

on SecretChanged => sub {
    my ($self, $event) = @_;
    
    sprintf qq{psst: just heard of a secret named "%s" which stores the phrase "%s"\n},
        $event->key,
        $event->phrase;
};

=head1 METHODS

=cut

__PACKAGE__->meta->make_immutable;
1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
