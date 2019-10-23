# Class: proxysql::repo
# ===========================
#
# Manage the repos where the ProxySQL package might be
#
class proxysql::repo {
  assert_private()

  if $proxysql::manage_repo and !$proxysql::package_source {
    $repo = $proxysql::version ? {
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
        yumrepo { 'proxysql_repo':
          * => $repo,
        }
      }
      default: {
        fail('This operatingsystem is not supported (yet).')
      }
    }
  }
}
