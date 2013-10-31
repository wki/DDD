package Hello;
use DDD::Domain;

=head1 NAME

Hello - a very simple domain without any subdomains

=head1 SYNOPSIS

    # construct or access domain
    my $hello = Hello->instance( name => 'hi' );
    
    # access service
    $hello->printer->echo('world'); # prints 'hi: world'

=head1 DESCRIPTION

This class demonstrates a very simple domain. It does not have a subdomain,
but simply a service. The service has an attribute C<name>, which will get
filled with the domain's C<name> attribute when constructed.

=cut

=head1 ATTRIBUTES

=head2 name

a simple name defined at construction time

=cut

has name => (
    is  => 'ro',
    isa => 'Str',
);

=head1 SERVICES

=head2 printer

a printer Service

=cut

service printer => (
    # isa => 'Hello::Printer', # is default
    dependencies => { name => dep('/name') },
);

1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
