# == Class proxysql::params
#
# This class is meant to be called from proxysql.
# It sets variables according to platform.
#
class proxysql::params {
  $package_name  = 'proxysql'
  $package_ensure = 'installed'
  $package_install_options = []

  $service_name = 'proxysql'
  $service_ensure = 'running'

  $listen_ip     = '0.0.0.0'
  $listen_port   = 6033
  $listen_socket = '/tmp/proxysql.sock'

  $admin_username      = 'admin'
  $admin_password      = Sensitive('admin')
  $admin_listen_ip     = '127.0.0.1'
  $admin_listen_port   = 6032

  $admin_listen_socket = '/tmp/proxysql_admin.sock'
  $sys_owner           = 'root'
  $sys_group           = 'root'

  case $facts['os']['family'] {
    'Debian': {
      $package_provider = 'dpkg'
      $package_source   = 'https://github.com/sysown/proxysql/releases/download/v1.4.7/proxysql_1.4.7-ubuntu16_amd64.deb'
      $repo             = {
        comment  => 'ProxySQL APT repository',
        location => "http://repo.proxysql.com/ProxySQL/proxysql-1.4.x/${::facts['os']['distro']['codename']}/",
        release  => './',
        repos    => '',
        key      => {
          'id'     => '1448BF693CA600C799EB935804A562FB79953B49',
          'server' => 'keyserver.ubuntu.com',
        },
      }
    }
    'RedHat': {
      $package_provider = 'rpm'
      $package_source   = 'https://github.com/sysown/proxysql/releases/download/v1.4.7/proxysql-1.4.7-1-centos7.x86_64.rpm'
      $repo             = {
        descr    => 'ProxySQL YUM repository',
        baseurl  => 'http://repo.proxysql.com/ProxySQL/proxysql-1.4.x/centos/$releasever',
        enabled  => true,
        gpgcheck => true,
        gpgkey   => 'http://repo.proxysql.com/ProxySQL/repo_pub_key',
      }
    }
    default: {
      $package_provider = undef
    }
  }


  $monitor_username = 'monitor'
  $monitor_password = Sensitive('monitor')

  $datadir = '/var/lib/proxysql'

  $config_file        = '/etc/proxysql.cnf'
  $manage_config_file = true

  $mycnf_file_name   = '/root/.my.cnf'
  $manage_mycnf_file = true

  $restart = false

  $load_to_runtime = true
  $save_to_disk    = true

  $config_settings = {
    datadir => $datadir,
    admin_variables => {
      admin_credentials => "${admin_username}:${admin_password}",
      mysql_ifaces => "${admin_listen_ip}:${admin_listen_port};${admin_listen_socket}",
    },
    mysql_variables => {
      interfaces => "${listen_ip}:${listen_port};${listen_socket}",
    },
    mysql_servers => {},
    mysql_users => {},
    mysql_query_rules => {},
    scheduler => {},
    mysql_replication_hostgroups => {},
  }

}
