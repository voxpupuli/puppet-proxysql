# == Class proxysql::install
#
# This class is called from proxysql for install.
#
class proxysql::install {

  if !$::proxysql::manage_repo {
    package { $::proxysql::package_name:
      ensure          => $::proxysql::package_ensure,
      source          => $::proxysql::package_source,
      provider        => $::proxysql::package_provider,
      install_options => $::proxysql::package_install_options,
    }
  } else {
    package { $::proxysql::package_name:
      ensure          => $::proxysql::package_ensure,
      install_options => $::proxysql::package_install_options,
    }
  }

  group { $::proxysql::sys_group:
    ensure => 'present',
  }

  user { $::proxysql::sys_owner:
    ensure => 'present',
    groups => $::proxysql::sys_group,
  }

  file { 'proxysql-datadir':
    ensure => directory,
    path   => $::proxysql::datadir,
    owner  => $::proxysql::sys_owner,
    group  => $::proxysql::sys_group,
    mode   => '0600',
  }

  class { '::mysql::client':
    package_name    => 'mysql-client',
    package_ensure  => 'present',
    bindings_enable => false,
  }

}
