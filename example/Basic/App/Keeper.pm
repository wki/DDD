package Basic::App::Keeper;
use DDD::Service;

=head1 NAME

Basic::App::Keeper - our keeper app service

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

=head2 keep_secret ( $key, $phrase )

keep a secret in a hidden place

=cut

sub keep_secret {
    my ($self, $key, $phrase) = @_;
    
    my $vault = $self->domain->vault;
    
    my $secret = $vault->all_secrets->by_key($key)
        // $vault->secret_creator->new_secret($key);
    
    $secret->change_phrase($phrase);
    
    $vault->all_secrets->save($secret);
}

=head2 retrieve_phrase ( $key )

retrieve the phrase stored under some key

=cut

sub retrieve_phrase {
    my ($self, $key) = @_;
    
    my $vault = $self->domain->vault;
    my $secret = $vault->all_secrets->by_key($key);
    
    return $secret ? $secret->phrase : ();
}

__PACKAGE__->meta->make_immutable;
1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
