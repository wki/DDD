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
        isa          => 'FileService', 
        dependencies => [ 'log' ],
    );
    
    factory thing_builder => (
        isa => 'ThingBuilder', # My::Domain::*
    );
    
    repository all_things => (
        isa          => 'AllThings::DBIC', # My::Domain::*
        depandencies => {
            schema  => dep('/schema'),
        }
    );
    
    subdomain measurement => (
        isa => 'Measurement', # My::Domain::*
        dependencies => {
            # reference to global schema
            schema  => dep('/schema'),
            
            # reference to this class log
            log     => 'log',
        },
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