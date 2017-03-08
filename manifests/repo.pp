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
      'CentOS', 'Fedora', 'Scientific', 'RedHat', 'Amazon', 'OracleLinux': {
	yumrepo { $::proxysql::params::rpm_repo_name:
	  descr    => $::proxysql::params::rpm_repo_descr,
          baseurl  => $::proxysql::params::rpm_repo,
	  enabled  => true,
	  gpgcheck => true,
	  gpgkey   => $::proxysql::params::rpm_repo_key,
	}
      }
      default: {
        fail('This operatingsystem is not supported (yet).')
      }
    }
  }
}
