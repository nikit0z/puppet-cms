class profile::tomcat (
) {
}

class profile::cms (
) {
}

class profile::mongo::primary (
) {
  
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
  } 
}
