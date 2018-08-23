# == Class proxysql::config
#
# This class is called from proxysql for service config.
#
class proxysql::config {

  $config_settings = $::proxysql::config_settings

  group { $::proxysql::sys_group:
    ensure => 'present',
  }

  user { $::proxysql::sys_owner:
    ensure => 'present',
    groups => $::proxysql::sys_group,
  }

  file { 'proxysql-datadir':
    ensure => directory,
    path   => $proxysql::datadir,
    owner  => $proxysql::sys_owner,
    group  => $proxysql::sys_group,
    mode   => '0600',
  }

  file { 'proxysql-config-directory':
      ensure => directory,
      path   => $proxysql::config_directory,
      mode   => '0640',
      owner  => $proxysql::sys_owner,
      group  => $proxysql::sys_group,
  }

  file { 'proxysql-main-config-file':
      ensure  => file,
      notify  => Service[$proxysql::service_name],
      path    => $proxysql::main_config_file,
      content => template('proxysql/proxysql.cnf.erb'),
      mode    => '0640',
      owner   => $proxysql::sys_owner,
      group   => $proxysql::sys_group,
      replace => $proxysql::manage_main_config_file,
  }

  file { 'proxysql-proxy-config-file':
      ensure  => file,
      path    => "${proxysql::config_directory}/${proxysql::proxy_config_file}",
      content => template('proxysql/proxysql_proxy.cnf.erb'),
      mode    => '0640',
      owner   => $proxysql::sys_owner,
      group   => $proxysql::sys_group,
      replace => $proxysql::manage_proxy_config_file,
  }

}
