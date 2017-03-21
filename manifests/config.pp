# == Class proxysql::config
#
# This class is called from proxysql for service config.
#
class proxysql::config {

  $config_settings = $::proxysql::config_settings
  if $proxysql::manage_config_file  {
    file { 'proxysql-config-file':
      ensure                  => file,
      path                    => $proxysql::config_file,
      content                 => template('proxysql/proxysql.cnf.erb'),
      mode                    => '0640',
      owner                   => $proxysql::params::sys_owner,
      group                   => $proxysql::params::sys_group,
      selinux_ignore_defaults => true,
    }
  }

  proxy_global_variable { 'admin-admin_credentials':
    value           => $config_settings['admin_variables']['admin_credentials'],
    load_to_runtime => false,
    notify          => Service[$::proxysql::service_name],
    before          => File['root-mycnf-file'],
  }

  proxy_global_variable { 'admin-mysql_ifaces':
    value           => $config_settings['admin_variables']['mysql_ifaces'],
    load_to_runtime => false,
    notify          => Service[$::proxysql::service_name],
    before          => File['root-mycnf-file'],
  }

  if $proxysql::manage_mycnf_file {
    file { 'root-mycnf-file':
      ensure  => file,
      path    => $proxysql::mycnf_file_name,
      content => template('proxysql/my.cnf.erb'),
      owner   => $proxysql::params::sys_owner,
      group   => $proxysql::params::sys_group,
      mode    => '0400',
    }
  }
}
