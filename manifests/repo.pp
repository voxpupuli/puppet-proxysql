# Class: proxysql::repo
# ===========================
#
# Manage the repos where the ProxySQL package might be
#
class proxysql::repo inherits proxysql {
  if $proxysql::manage_repo == true {
    case $facts['os']['family'] {
      'Debian': {
        create_resources('apt::source', { 'proxysql_repo' => $proxysql::repo})
      }
      'RedHat': {
        yumrepo { 'proxysql_repo':
        * => $proxysql::params::repo20,
        }
      }
      default: {
        fail('This operatingsystem is not supported (yet).')
      }
    }
  }
}
