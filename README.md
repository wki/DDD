# DDD #

base classes for a simple Domain-Driven-Design Layer

Goals:

* avoid logic in controllers

* keep the DBIC layer simple

* allow accessing misc infrastructure layers

* access current user or running environment


## Class Layout ##

MyApp::Model::Domain        access Domain -- via 'C::M::Factory::PerRequest'

MyApp::Domain               Domain Namespace and Bread::Board Container
MyApp::Domain::<<Aggregate>>
MyApp::Domain::<<Aggregate>>::Xxx
MyApp::Domain::XxxService


## Catalyst Configuration ##

    'Model::Domain' => {
        class => 'MyApp::Domain',
        args  => {
            schema      => sub { MyApp->model('DB')->schema },
            storage     => sub { MyApp->model('FileStorage') },
            log         => sub { MyApp->log },
            environment => sub { MyApp->environment },
        },
    },
    
    'Model::FileStorage' => {
        root_dir => __path_to(root/files)__,
    },


## Domain Class ##

The domain class is a Bread::Board container. Looks like this:

    package MyApp::Domain;
    use Moose;
    use namespace::autoclean;
    
    extends 'DDD::Domain';
    
    # services that look like attributes set via construction
    has log => ( ... );
    
    # services -- singleton lifecycle
    service fileservice => ( ... );
    
    # TODO: factory -- does this make sense? (implementation: same as service)
    factory order_builder => ( ... );
    
    # aggregates, internally consist of a _xxx service and an xxx accessor
    aggregate orderlist => ( ... );


## Usage inside Catalyst Controller ##

    # Example 1: initialize an aggregate and later load it
    my $agg = $c->model('Domain')->aggregate_name(%args);
    $agg->load($optional_id);
    $agg->method();
    $agg->save;
    
    # Example 2: initialize an aggregate with all we know
    my $agg = $c->model('Domain')->agg_name(id => $id, row => $row_obj);
    
    # Use a service by calling a method on it
    $c->model('Domain')->service_name->method_name();
    
    # Idea for a factory
    #  -- possible Problem: duplicated logic for validity-check
    #                       duplicated code for additional attributes
    $c->model('Domain')->order_builder->build(...);
    
    # Idea for a repository
    #  -- possible Problem: duplicated logic for validity-check
    #                       duplicated code for additional attributes
    $c->model('Domain')->order_repository->order_by_id(...);


## Infrastructure Layer -- more simple things ##

    FileStorage     -- handle files inside dir(storage/files)
    JobStorage      -- generate new Jobs

