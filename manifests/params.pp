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
              $package_source = 'https://github.com/sysown/proxysql/releases/download/v1.4.10/proxysql_1.4.10-debian8_amd64.deb'
              $package_checksum_value = '98bab1b7cd719039b1483f7d51c30d7fc563def7'
              $package_checksum_type = 'sha1'
              $package_dependencies = []
            }
            '9': {
              $package_source = 'https://github.com/sysown/proxysql/releases/download/v1.4.10/proxysql_1.4.10-debian9_amd64.deb'
              $package_checksum_value = 'd97a2f870e46d5f3218ab80d6c0db6bcc288127a'
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
              $package_source = 'https://github.com/sysown/proxysql/releases/download/v1.4.10/proxysql_1.4.10-ubuntu14_amd64.deb'
              $package_checksum_value = '0b89f290bd9cd7e8bc2b7acd8a7799840a31af94'
              $package_checksum_type = 'sha1'
              $package_dependencies = []
            }
            '16.04': {
              $package_source = 'https://github.com/sysown/proxysql/releases/download/v1.4.10/proxysql_1.4.10-ubuntu16_amd64.deb'
              $package_checksum_value = 'df8695c6296678a0eeda036cddff679cc1ff604e'
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
      $package_source   = 'https://github.com/sysown/proxysql/releases/download/v1.4.10/proxysql-1.4.10-1-centos67.x86_64.rpm'
      $package_checksum_value = 'f5ca4efa9d69e9bd6ba9a96c724b031cd7326051'
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

  $config_file        = '/etc/proxysql.cnf'
  $manage_config_file = true

  $mycnf_file_name   = '/root/.my.cnf'
  $manage_mycnf_file = true

  $restart = false

  $load_to_runtime = true
  $save_to_disk    = true

  $cluster_name = undef
  $cluster_username = 'cluster'
  $cluster_password = Sensitive('cluster')

  $cluster_name = undef
  $cluster_username = 'cluster'
  $cluster_password = Sensitive('cluster')

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
