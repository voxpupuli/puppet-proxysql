# Class: proxysql::repo
# ===========================
#
# Manage the repos where the ProxySQL package might be
#
class proxysql::repo inherits proxysql {
  if ($::proxysql::manage_repo == true) and ($::proxysql::manage_rpm == false) {
    case $::operatingsystem {
      'Debian': {
        create_resources('::apt::source', $::proxysql::repo)
      }
      'CentOS', 'Fedora', 'Scientific', 'RedHat', 'Amazon', 'OracleLinux': {
        yumrepo { $::proxysql::rpm_repo_name:
          descr    => $::proxysql::rpm_repo_descr,
          baseurl  => $::proxysql::rpm_repo,
          enabled  => true,
          gpgcheck => true,
          gpgkey   => $::proxysql::rpm_repo_key,
        }
      }
      default: {
        fail('This operatingsystem is not supported (yet).')
      }
    }
  }
}
