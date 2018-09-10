# Class: proxysql::prerequisites
# ===========================
#
# Manage the prerequisites where the ProxySQL package might be
#
class proxysql::prerequisites inherits proxysql {
  if $proxysql::sys_owner != 'root' { # let's assume that 'root' will exist and not touch that...
    group { $proxysql::sys_group:
      ensure => 'present',
    }

    user { $proxysql::sys_owner:
      ensure => 'present',
      groups => $proxysql::sys_group,
    }
  }

}
