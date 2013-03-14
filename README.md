# DDD #

base classes for a simple Domain-Driven-Design Layer

Goal is avoid logic in controllers and to keep the DBIC layer simple.


## Class Layout ##

MyApp::Model::Domain        access Domain -- via 'C::M::Factory::PerRequest'

MyApp::Domain               Domain Namespace and Bread::Board Container
MyApp::Domain::<<Aggregate>>
MyApp::Domain::<<Aggregate>>::Xxx
MyApp::Domain::XxxService


## Expansion of Catalyst::Plugin::ConfigLoader ##
  __model(Xxx)__    -- model Xxx instance
  __view(Xxx)__     -- view Xxx instance
  __log__           -- logger instance
  __c(method, x)__  -- result of $c->method('x')
  
  TODO (evtl. inside My::Catalyst::Base)
    MyApp->config->{'Plugin::ConfigLoader'}->{substitutions} = {
        c     => sub { my $c = shift; my $method = shift; $c->$method(@_) },
        model => sub { my $c = shift; my $model  = shift; $c->model($model) },
        view  => sub { my $c = shift; my $view   = shift; $c->view($view) },
        log   => sub { my $c = shift;                     $c->log },
    };


## Catalyst Configuration ##

'Model::Domain' => {
    class       => 'MyApp::Domain',
    schema      => __model(DB)__,
    storage     => __model(FileStorage)__
    log         => __log__,       # alt: __c(log)__
    is_live     => __c(is_live)__,
},

# more meaningful would be 'Infrastructure::Something' ...
'Model::FileStorage' => {
    storage_dir => __path_to(root/files)__,
},


## Usage inside Catalyst Controller ##

    my $agg = $c->model('Domain')->aggregate_name(%args);
    $agg->load($optional_id);
    $agg->method();
    $agg->save;
    
    $c->model('Domain')->service_name->method_name();

