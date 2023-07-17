# @summary Manage the repos where the ProxySQL package might be.
#
# @api private
class proxysql::repo {
  assert_private()

  if $proxysql::manage_repo and !$proxysql::package_source {
    $repo = $proxysql::version ? {
      /^2\.5\./ => $proxysql::params::repo25,
      /^2\.4\./ => $proxysql::params::repo24,
      /^2\.3\./ => $proxysql::params::repo23,
      /^2\.2\./ => $proxysql::params::repo22,
      /^2\.1\./ => $proxysql::params::repo21,
      /^2\.0\./ => $proxysql::params::repo20,
      /^1\.4\./ => $proxysql::params::repo14,
      default   => fail("Unsupported `proxysql::version` ${proxysql::version}")
    }
    case $facts['os']['family'] {
      'Debian': {
        apt::source { 'proxysql_repo':
          * => $repo,
        }
        Class['apt::update'] -> Package[$proxysql::package_name]
      }
      'RedHat': {
        yumrepo { $repo['name']:
          * => $repo,
        }

        # Purge old/unnecessary repos.
        if ($proxysql::version !~ /^2\.5\./) {
          yumrepo { $proxysql::params::repo25['name']:
            ensure => absent,
          }
        }
        if ($proxysql::version !~ /^2\.4\./) {
          yumrepo { $proxysql::params::repo24['name']:
            ensure => absent,
          }
        }
        if ($proxysql::version !~ /^2\.3\./) {
          yumrepo { $proxysql::params::repo23['name']:
            ensure => absent,
          }
        }
        if ($proxysql::version !~ /^2\.2\./) {
          yumrepo { $proxysql::params::repo22['name']:
            ensure => absent,
          }
        }
        if ($proxysql::version !~ /^2\.1\./) {
          yumrepo { $proxysql::params::repo21['name']:
            ensure => absent,
          }
        }
        if ($proxysql::version !~ /^2\.0\./) {
          yumrepo { $proxysql::params::repo20['name']:
            ensure => absent,
          }
        }
        if ($proxysql::version !~ /^1\.4\./) {
          yumrepo { $proxysql::params::repo14['name']:
            ensure => absent,
          }
        }

        yumrepo { 'proxysql_repo':
          ensure => absent,
        }
      }
      default: {
        fail('This operatingsystem is not supported (yet).')
      }
    }
  }
}
