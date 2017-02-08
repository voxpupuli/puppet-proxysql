# Class: proxysql::repo
# ===========================
#
# Manage the repos where the ProxySQL package might be
#
class proxysql::repo inherits proxysql {
  if $::proxysql::manage_repo {
    case $::operatingsystem {
      'Debian': {
        create_resources('::apt::source', $::proxysql::repo)
      }
      default: {
        fail('This operatingsystem is not supported (yet).')
      }
    }
  }
}
