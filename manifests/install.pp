# == Class proxysql::install
#
# This class is called from proxysql for install.
#
class proxysql::install {

  package { $::proxysql::package_name:
    ensure          => $::proxysql::package_ensure,
    install_options => $::proxysql::package_install_options,
  }

  file { 'proxysql-datadir':
    ensure => directory,
    path   => $::proxysql::datadir,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  class { '::mysql::client':
    bindings_enable => false,
  }

}
