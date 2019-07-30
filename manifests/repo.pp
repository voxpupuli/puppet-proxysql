# Class: proxysql::repo
# ===========================
#
# Manage the repos where the ProxySQL package might be
#
class proxysql::repo inherits proxysql {
  if $proxysql::manage_repo == true and !$proxysql::package_source {
    case $facts['os']['family'] {
      'Debian': {
        case $proxysql::repo_version {
          '2.0.x': {
            create_resources('apt::source', { 'proxysql_repo' => $proxysql::repo20})
          }
          '1.4.x': {
            create_resources('apt::source', { 'proxysql_repo' => $proxysql::repo14})
          }
          default: {
            create_resources('apt::source', { 'proxysql_repo' => $proxysql::repo14})
          }
        }
        Class['apt::update'] -> Package[$proxysql::package_name]
      }
      'RedHat': {
        case $proxysql::repo_version {
          '2.0.x': {
            yumrepo { 'proxysql_repo':
            * => $proxysql::repo20,
            }
          }
          '1.4.x': {
            yumrepo { 'proxysql_repo':
            * => $proxysql::repo14,
            }
          }
          default: {
            yumrepo { 'proxysql_repo':
            * => $proxysql::repo14,
            }
          }
        }
      }
      default: {
        fail('This operatingsystem is not supported (yet).')
      }
    }
  }
}
