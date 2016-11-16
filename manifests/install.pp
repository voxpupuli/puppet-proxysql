# == Class proxysql::install
#
# This class is called from proxysql for install.
#
class proxysql::install {

  package { $::proxysql::package_name:
    ensure => present,
  }

  file { 'proxysql-datadir':
    path  => $::proxysql::datadir,
    owner => 'root',
    group => 'root',
    mode  => '0600',
  }
  class { '::mysql::client':
    bindings_enable => false
  }
}
