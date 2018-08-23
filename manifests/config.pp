# == Class proxysql::config
#
# This class is called from proxysql for service config.
#
class proxysql::config {

  $config_settings = $::proxysql::config_settings
  $proxy_config_file = $::proxysql::proxy_config_file

  if $proxysql::manage_config_file  {
    file { 'proxysql-config-file':
      ensure                  => file,
      path                    => $proxysql::config_file,
      content                 => template('proxysql/proxysql.cnf.erb'),
      mode                    => '0640',
      owner                   => $proxysql::sys_owner,
      group                   => $proxysql::sys_group,
      selinux_ignore_defaults => true,
    }
  }

  if $proxysql::split_config {
    file { 'proxysql-proxy-config-file':
      ensure  => file,
      path    => $proxysql::proxy_config_file,
      content => template('proxysql/proxysql_proxy.cnf.erb'),
      mode    => '0640',
      owner   => $proxysql::sys_owner,
      group   => $proxysql::sys_group,
      selinux_ignore_defaults => true,
      replace => $proxysql::manage_proxy_config_file,
    }
  }
}
