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
      case $facts['os']['name'] {
        'Debian': {
          case $facts['os']['release']['major'] {
            '8': {
              $package_source = 'https://github.com/sysown/proxysql/releases/download/v1.4.11/proxysql_1.4.11-debian8_amd64.deb'
              $package_checksum_value = '813a91ea030ef480c0210b047df5e88ff1c27810'
              $package_checksum_type = 'sha1'
              $package_dependencies = []
            }
            '9': {
              $package_source = 'https://github.com/sysown/proxysql/releases/download/v1.4.11/proxysql_1.4.11-debian9_amd64.deb'
              $package_checksum_value = '65a3c2b98eefa42946ee59eef18ba18534c2a39d'
              $package_checksum_type = 'sha1'
              $package_dependencies = []
          }
            default: {
              $package_source = undef
              $package_checksum_value = undef
              $package_checksum_type = undef
              $package_dependencies = []
          }
          }
        }
        'Ubuntu': {
          case $facts['os']['release']['major'] {
            '14.04': {
              $package_source = 'https://github.com/sysown/proxysql/releases/download/v1.4.11/proxysql_1.4.11-ubuntu14_amd64.deb'
              $package_checksum_value = '42b99a12e8e43410aed88da4c5bbe902c43dbba1'
              $package_checksum_type = 'sha1'
              $package_dependencies = []
            }
            '16.04': {
              $package_source = 'https://github.com/sysown/proxysql/releases/download/v1.4.11/proxysql_1.4.11-ubuntu16_amd64.deb'
              $package_checksum_value = '6e7db2fee78eee1a22cdfabefaa50953c3d24501'
              $package_checksum_type = 'sha1'
              $package_dependencies = []
            }
            '18.04': {
              # no upstream bionic builds are provided yet.
              $package_source = undef
              $package_checksum_value = undef
              $package_checksum_type = undef
              $package_dependencies = []
            }
            default: {
              $package_source = undef
              $package_checksum_value = undef
              $package_checksum_type = undef
              $package_dependencies = []
            }
          }
        }
        default: {}
      }
      $repo             = {
        comment  => 'ProxySQL APT repository',
        location => "http://repo.proxysql.com/ProxySQL/proxysql-1.4.x/${facts['lsbdistcodename']}/",
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
      $package_source   = 'https://github.com/sysown/proxysql/releases/download/v1.4.11/proxysql-1.4.11-1-centos67.x86_64.rpm'
      $package_checksum_value = '6f302beaea096b63851a136287818a1b6e049e28'
      $package_checksum_type = 'sha1'
      $package_dependencies = ['perl-DBI', 'perl-DBD-mysql']
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

  $permissions = '0600'

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
  }

}
