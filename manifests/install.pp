# == Class proxysql::install
#
# This class is called from proxysql for install.
#
class proxysql::install {

  if $proxysql::package_source {
    case $facts['os']['family'] {
      'Debian': {
        $real_package_source = '/root/proxysql-package.deb'

        archive { $real_package_source:
          ensure        => present,
          source        => $proxysql::package_source,
          checksum      => $proxysql::package_checksum_value,
          checksum_type => $proxysql::package_checksum_type,
          before        => Package[$proxysql::package_name],
        }
      }
      default: {
        $real_package_source = $proxysql::package_source
      }
    }

    ensure_packages($proxysql::package_dependencies)
    package { $proxysql::package_name:
      ensure          => $proxysql::package_ensure,
      source          => $real_package_source,
      provider        => $proxysql::package_provider,
      install_options => $proxysql::package_install_options,
    }
  } else {
    # Install from a repo
    package { $proxysql::package_name:
      ensure          => $proxysql::package_ensure,
      install_options => $proxysql::package_install_options,
    }
  }

  file { 'proxysql-datadir':
    ensure => directory,
    path   => $proxysql::datadir,
    owner  => $proxysql::sys_owner,
    group  => $proxysql::sys_group,
    mode   => $proxysql::datadir_mode,
  }

  if $proxysql::manage_mysql_client {
    class { 'mysql::client':
      package_name    => $proxysql::mysql_client_package_name,
      bindings_enable => false,
    }

    Class['mysql::client::install']
    -> Class['proxysql::admin_credentials']

    Class['mysql::client::install']
    -> Class['proxysql::reload_config']
  }

}
