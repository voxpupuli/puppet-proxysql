# == Class proxysql::params
#
# This class is meant to be called from proxysql.
# It sets variables according to platform.
#
class proxysql::params {
  $package_name  = 'proxysql'
  $mysql_client_package_name = undef
  $package_ensure = 'installed'
  $package_install_options = []

  $service_name = 'proxysql'
  $service_ensure = 'running'

  $listen_ip     = '0.0.0.0'
  $listen_port   = 6033

  $admin_username      = 'admin'
  $admin_password      = Sensitive('admin')
  $admin_listen_ip     = '127.0.0.1'
  $admin_listen_port   = 6032

  $datadir = '/var/lib/proxysql'
  $datadir_mode = '0600'

  case $facts['os']['family'] {
    'Debian': {
      $package_provider = 'dpkg'
      $package_dependencies = []

      if $facts['os']['release']['major'] == '18.04' {
        # The 2.0.x systemd service file in ubuntu 18.04 has `ReadWritePaths=/var/lib/proxysql /var/run/proxysql`.
        # This limits where we can write sockets.
        $_listen_socket = "${datadir}/proxysql.sock"
        $_admin_listen_socket = "${datadir}/proxysql_admin.sock"
      }

      $repo14             = {
        comment  => 'ProxySQL 1.4.x APT repository',
        location => "http://repo.proxysql.com/ProxySQL/proxysql-1.4.x/${facts['os']['distro']['codename']}/",
        release  => './',
        repos    => '',
        key      => {
          'id'     => '1448BF693CA600C799EB935804A562FB79953B49',
          'server' => 'keyserver.ubuntu.com',
        },
      }
      $repo20             = {
        comment  => 'ProxySQL 2.0.x APT repository',
        location => "http://repo.proxysql.com/ProxySQL/proxysql-2.0.x/${facts['os']['distro']['codename']}/",
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
      $package_dependencies = ['perl-DBI', 'perl-DBD-mysql']
      $repo14             = {
        descr    => 'ProxySQL 1.4.x YUM repository',
        baseurl  => "http://repo.proxysql.com/ProxySQL/proxysql-1.4.x/centos/${facts['os']['release']['major']}",
        enabled  => true,
        gpgcheck => true,
        gpgkey   => 'http://repo.proxysql.com/ProxySQL/repo_pub_key',
      }
      $repo20             = {
        descr    => 'ProxySQL 2.0.x YUM repository',
        baseurl  => "http://repo.proxysql.com/ProxySQL/proxysql-2.0.x/centos/${facts['os']['release']['major']}",
        enabled  => true,
        gpgcheck => true,
        gpgkey   => 'http://repo.proxysql.com/ProxySQL/repo_pub_key',
      }
    }
    default: {
      fail("osfamily ${facts['os']['family']} is not supported")
    }
  }

  if fact('proxysql_version') {
    $short_proxysql_version_fact = regsubst(fact('proxysql_version'),'^(\\d+\\.\\d+\\.\\d+)','\\1')
  } else {
    $short_proxysql_version_fact = undef
  }
  $version = pick($short_proxysql_version_fact,'2.0.7')

  $listen_socket = pick(getvar('_listen_socket'),'/tmp/proxysql.sock')
  $admin_listen_socket = pick(getvar('_admin_listen_socket'),'/tmp/proxysql_admin.sock')

  $monitor_username = 'monitor'
  $monitor_password = Sensitive('monitor')


  $split_config             = false
  $config_file              = '/etc/proxysql.cnf'
  $manage_config_file       = true
  $proxy_config_file        = '/etc/proxysql_proxy.cnf'
  $manage_proxy_config_file = true

  $mycnf_file_name   = '/root/.my.cnf'
  $manage_mycnf_file = true

  $restart = false

  $load_to_runtime = true
  $save_to_disk    = true

  $cluster_name = undef
  $cluster_username = 'cluster'
  $cluster_password = Sensitive('cluster')
  $manage_hostgroup_for_servers = true

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
    mysql_group_replication_hostgroups => {},
    mysql_galera_hostgroups => {},
  }

}
