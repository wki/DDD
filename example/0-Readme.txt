Example domains

Simple   -- contains one service with one method
            * Print-Service

Basic    -- contains 2 subdomains and an application
            and an application with a service as an API from outside
            * Subdomain "Vault" keeping a phrase under a secret key
            * Subdomain "Spy" observing and reveiling phrase changes
            * Application with a service "keeper"

TODO:
Advanced -- what else can we do?
            * domain attributes (eg. DBIC, directory, logger)
            * several subdomains
