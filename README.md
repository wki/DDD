# DDD #

base classes for a simple Domain-Driven-Design Layer

Goals:

* avoid logic in controllers

* allow accessing misc infrastructure layers

* access current user or running environment

* simple PubSub mechanism for inter-process communication


## Class Layout ##

MyApp::Model::Domain        access Domain -- via 'C::M::Factory::PerRequest'

MyApp::Domain               Domain Namespace and Bread::Board Container
MyApp::Domain::SubDomain::<<Aggregate>>
MyApp::Domain::SubDomain::<<Aggregate>>::Xxx
MyApp::Domain::SubDomain::XxxService


## Catalyst Configuration ##

    # define all infrastructural things to be known by our domain
    'Model::Domain' => {
        class => 'MyApp::Domain',
        args  => {
            schema      => sub { shift->model('DB')->schema },
            storage     => sub { shift->model('FileStorage') },
            log         => sub { shift->log },
            environment => sub { shift->environment },
        },
    },
    
    # some other model which may get used by the domain
    'Model::FileStorage' => {
        root_dir => __path_to(root/files)__,
    },


## Domain Class ##

The domain class is a Bread::Board container. It defines all infrastructure
things as regular Moose attributes. All these attributes must get set via
args in the Model::Domain config.

    package MyApp::Domain;
    use 'DDD::Domain';
    
    # attribute values are set via Model configuration
    # FIXME: maybe we should think about lazy evaluation
    attr schema      => ( ... );
    attr storage     => ( ... );
    attr log         => ( ... );
    attr environment => ( ... );
    
    ### FIXME: do re really need to define everything twice?
    ###        if all attributes have the very same name as the attributes
    ###        of our domain, there would be no need.
    
    # services -- singleton lifecycle
    service fileservice => ( ... );
    
    # TODO: factory -- does this make sense? (implementation: same as service)
    factory order_builder => ( ... );
    
    # aggregates, internally consist of a _xxx service and an xxx accessor
    aggregate orderlist => ( ... );
    
    # TODO: subdomain -- allow hierarchical definition
    # allow to call $domain->sales->some_service->some_method;
    subdomain sales => ( ... );

### Subdomain ###

    package MyDomain::Sales;
    use Moose;
    use namespace::autoclean;
    
    extends 'DDD::Subdomain';    # or Domain ???

    # same definitions as above. except dependencies may have a path
    
    service order_import => (
        isa => 'MyDomain::Sales::OrderImport',
        dependencies => {
            schema => dep('/schema'),
        }
    );

## Classes inside Domain ##


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

