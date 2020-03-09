# == Class proxysql::admin_credentials
#
# This class is called from proxysql for service config.
#
class proxysql::admin_credentials {

  if $proxysql::manage_mycnf_file {
    $mycnf_file_name = $proxysql::mycnf_file_name
    $admin_credentials = $proxysql::config_settings['admin_variables']['admin_credentials']
    $admin_interfaces = $proxysql::config_settings['admin_variables']['mysql_ifaces']
    exec { 'proxysql-admin-credentials':
      command => "/usr/bin/mysql --defaults-extra-file=${mycnf_file_name} --execute=\"
        SET admin-admin_credentials = '${admin_credentials}'; \
        SET admin-mysql_ifaces = '${admin_interfaces}'; \
        LOAD ADMIN VARIABLES TO RUNTIME; \
        SAVE ADMIN VARIABLES TO DISK;\"
      ",
      onlyif  => "/usr/bin/test \
        `/usr/bin/mysql --defaults-extra-file=${mycnf_file_name} -BN \
          --execute=\"SELECT variable_value FROM global_variables WHERE variable_name='admin-admin_credentials'\"` != '${admin_credentials}' \
        -o `/usr/bin/mysql --defaults-extra-file=${mycnf_file_name} -BN \
          --execute=\"SELECT variable_value FROM global_variables WHERE variable_name='admin-mysql_ifaces'\"` != '${admin_interfaces}'
      ",
      before  => File['root-mycnf-file'],
    }

    file { 'root-mycnf-file':
      ensure  => file,
      path    => $proxysql::mycnf_file_name,
      content => template('proxysql/my.cnf.erb'),
      owner   => $proxysql::sys_owner,
      group   => $proxysql::sys_group,
      mode    => '0400',
    }

    # This is to keep track of my cnf file.
    # This is used by custom proxy_* resources
    file { '/root/.proxysql_mycnf_file_name':
      ensure  => file,
      content => "${proxysql::mycnf_file_name}",
    }
  }

}
