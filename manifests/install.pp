# == Class proxysql::install
#
# This class is called from proxysql for install.
#
class proxysql::install {

  if !$proxysql::manage_repo {
    case $facts['os']['family'] {
      'Debian': {
        archive { '/root/proxysql-package.deb':
          ensure        => present,
          source        => $proxysql::package_source,
          checksum      => $proxysql::package_checksum_value,
          checksum_type => $proxysql::package_checksum_type,
        }

        $real_package_source = '/root/proxysql-package.deb'
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
    mode   => '0600',
  }

  class { '::mysql::client':
    bindings_enable => false,
  }

}
