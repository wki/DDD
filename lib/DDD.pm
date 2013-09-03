package DDD;

=head1 NAME

DDD - base classes for DDD models

=head1 SYNOPSIS

    package My::Domain;
    use DDD::Domain;
    
    has schema => (
        is  => 'ro',
        isa => 'DBIx::Class::Schema',
    );
    
    has log => (
        is  => 'ro',
        isa => 'Object',
    );
    
    service file_service => (
        isa          => 'FileService', # will expand to My::Domain::FileService
        dependencies => [ 'log' ],
    );
    
    # aggregate orderlist => (
    #     isa          => '+My::Orderlist', # no prefix inserted
    #     dependencies => [ 'schema', 'log' ],
    #     parameters   => {
    #         foo => { isa => 'Int', optional => 1 },
    #     },
    # );
    
    1;

=head1 DESCRIPTION

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;