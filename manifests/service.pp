# == Class proxysql::service
#
# This class is meant to be called from proxysql.
# It ensure the service is running.
#
class proxysql::service {

  if $::proxysql::manage_config_file {
    $service_require = File['proxysql-config-file']
  } else {
    $service_require = undef
  }

  if $::proxysql::restart {
    service { $::proxysql::service_name:
      ensure     => $::proxysql::service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => false,
      provider   => 'base',
      status     => '/etc/init.d/proxysql status',
      start      => '/usr/bin/proxysql --reload',
      stop       => '/etc/init.d/proxysql stop',
      require    => $service_require,
    }
  } else {
    service { $::proxysql::service_name:
      ensure     => $::proxysql::service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      require    => $service_require,
    }
  }

  exec { 'wait_for_admin_socket_to_open':
    command   => "test -S ${::proxysql::admin_listen_socket}",
    unless    => "test -S ${::proxysql::admin_listen_socket}",
    tries     => '3',
    try_sleep => '10',
    require   => Service[$::proxysql::service_name],
    path      => '/bin:/usr/bin',
  }

}
