package Basic;
use DDD::Domain;

=head1 NAME

Basic - a domain with two subdomains loosely coupled

=head1 SYNOPSIS

    # construct domain
    my $basic = Basic->instance;
    
    # create a new secret from a key and a phrase
    my $secret = $basic->vault->secret_generator(pssst => 'Hide me');
    
    # save the secret to our vault
    $basic->vault->all_secreta->save($secret);
    
    # retrieve a secret
    my $top_secret = $basic->vault->all_secrets->by_key('pssst');
    
    say $top_secret->word; # prints 'Hide me'

=head1 DESCRIPTION

This example domain shows two subdomains:

=over

=item Vault

saves words under a secret key

=item Spy

observes save operations and reveils the secrets saved

=back

=head1 SUBDOMAINS

=cut

=head2 Vault

This is the core subdomain which is responsible for managing our secret
phrases.

=cut

subdomain 'vault';

=head2 Spy

The spy subdomain observes changes for secrets and reveils the secrets. There
is no direct link betweeen spy and vault, just an event that is observed.

=cut

subdomain 'spy';

=head1 APPLICATION

The application offers the API to the outside world.

=cut

application;

__PACKAGE__->meta->make_immutable;
1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
