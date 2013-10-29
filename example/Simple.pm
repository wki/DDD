package Simple;
use DDD::Domain;

=head1 NAME

Simple - a very simple domain without any subdomains

=head1 SYNOPSIS

    # construct or access domain
    my $simple = Simple->instance( name => 'foo' );
    
    # access service
    $simple->printer->echo('hello'); # prints 'foo: hello'

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
    # isa => 'Simple::Printer', # is default
    dependencies => { name => dep('/name') },
);

1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
