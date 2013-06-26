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
            schema      => sub { shift->model('DB')->schema },
            storage     => sub { shift->model('FileStorage') },
            log         => sub { shift->log },
            environment => sub { shift->environment },
        },
    },
    
    'Model::FileStorage' => {
        root_dir => __path_to(root/files)__,
    },


## Domain Class ##

The domain class is a Bread::Board container. It defines all infrastructure
things as regular Moose attributes. All these attributes must get set via
args in the Model::Domain config.

    package MyApp::Domain;
    use Moose;
    use namespace::autoclean;
    
    extends 'DDD::Domain';
    
    # attribute values are set via Model configuration
    has log => ( ... );
    
    ### FIXME: do re really need to define everything twice?
    ###        if all attributes have the very same name as the attributes
    ###        of our domain, there would be no need.
    
    # services -- singleton lifecycle
    service fileservice => ( ... );
    
    # TODO: factory -- does this make sense? (implementation: same as service)
    factory order_builder => ( ... );
    
    # aggregates, internally consist of a _xxx service and an xxx accessor
    aggregate orderlist => ( ... );

## Classes inside Domain ##

Idea: can we "autowire" things?

    package MyApp::Domain::Xxx::ImportService;
    
    use Moose;
    use MyApp::Domain;
    use MyApp::Domain::Xxx::SomeOtherService;
    
    # OR: autowire => 1
    # OR: autowire => '/xxx/some_other_service',
    will_have some_other_service => (
        is => 'ro',
        isa => 'MyApp::Domain::Xxx::SomeOtherService',
    );
    
    # is the same as:
    has some_other_service => (
        is => 'ro',
        isa => 'MyApp::Domain::Xxx::SomeOtherService',
        lazy_build => 1,
    );
    
    sub _build_some_other_service {
        $_->[0]->domain('MyApp::Domain::Xxx::SomeOtherService')
    }


## Usage inside Catalyst Controller ##

    ### FIXME: does a shortcut $c->domain make sense?

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

