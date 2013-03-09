# DDD #

base classes for a simple Domain-Driven-Design Layer

Goal is avoid logic in controllers and to keep the DBIC layer simple.


## Class Layout ##

MyApp::Model::Domain        Catalyst Model -- instantiates MyApp::Domain::Xxx

MyApp::Domain               Domain Namespace and Bread::Board
MyApp::Domain::Xxx


## Configuration ##

'Model::Domain' => {
    class             => 'MyApp::Domain',
    schema_from_model => 'DB',
},


## Usage inside Catalyst Controller ##

    my $agg = $c->model('Domain')->aggregate_name;
    $agg->method();
    
    $c->model('Domain')->service_name->method_name();

