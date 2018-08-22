# == Class proxysql::install
#
# This class is called from proxysql for install.
#
class proxysql::install {

  class { '::mysql::client':
    package_name    => 'mysql-client',
    package_ensure  => 'present',
    bindings_enable => false,
  }

  package { $::proxysql::package_name:
      ensure          => $::proxysql::package_ensure,
      install_options => $::proxysql::package_install_options,
  }

}
