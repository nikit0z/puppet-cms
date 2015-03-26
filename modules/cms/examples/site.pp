class profile::tomcat {
  class { '::tomcat':
    install_from_source => false,
  }

  tomcat::instance{ 'default':
    package_name => 'tomcat',
  }->
  
  tomcat::service { 'default':
    use_jsvc     => false,
    use_init     => true,
    service_name => 'tomcat',
  }
}

class profile::cms {
}

class profile::mongo::primary {
  mongodb_replset { rscms:
    ensure  => present,
    members => hiera('mongo_nodes')
  }
}

class profile::mongo {
  # remove this on prod
  class {'::mongodb::globals':
    manage_package_repo => true,
  }->

  class {'::mongodb::server':
    verbose => hiera('verbose'),
    replset => 'rscms',
    bind_ip => ['0.0.0.0']
  }->

  class {'::mongodb::client':}
}

node default {
  $role = hiera('role')
 
  case $role {
    "mongo" : {
      include profile::mongo
    }
    
    "mongo-primary" : {
      include profile::mongo
      include profile::mongo::primary
    }
    
    "frontend" : {
      include profile::tomcat  
      include profile::cms
    }
  } 
}
