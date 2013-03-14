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
        schema  => sub { MyApp->model('DB') },
        storage => sub { MyApp->model('FileStorage') },
        log     => sub { MyApp->log },
        is_live => MyApp->is_live,
    },
},

'Model::FileStorage' => {
    storage_dir => __path_to(root/files)__,
},


## Usage inside Catalyst Controller ##

    my $agg = $c->model('Domain')->aggregate_name(%args);
    $agg->load($optional_id);
    $agg->method();
    $agg->save;
    
    $c->model('Domain')->service_name->method_name();

