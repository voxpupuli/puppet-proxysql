# == Class proxysql::service
#
# This class is meant to be called from proxysql.
# It ensure the service is running.
#
class proxysql::service {

  service { $::proxysql::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
