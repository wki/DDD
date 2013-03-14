# DDD #

base classes for a simple Domain-Driven-Design Layer

Goal is avoid logic in controllers and to keep the DBIC layer simple.


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
            schema  => MyApp->model('DB'),
            storage => sub { MyApp->model('FileStorage') }, # if per request
            log     => MyApp->log,
            is_live => MyApp->is_live,
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
    
    # aggregates, internally consist of a _xxx service and an xxx accessor
    aggregate orderlist => ( ... );
    
    # services -- singleton lifecycle
    service fileservice => ( ... );


## Usage inside Catalyst Controller ##

    my $agg = $c->model('Domain')->aggregate_name(%args);
    $agg->load($optional_id);
    $agg->method();
    $agg->save;
    
    $c->model('Domain')->service_name->method_name();


## Infrastructure Layer -- more simple things ##

    FileStorage     -- handle files inside dir(storage/files)
    JobStorage      -- generate new Jobs

