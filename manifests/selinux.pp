# @summary Adds selinux configuration needed for logrotate to work
#
# @api private
class proxysql::selinux {
  # lint:ignore:strict_indent
  $content_te = @(POLICY)
  module puppet-proxysql 1.0;

  require {
          class file read;
  }
  | POLICY
  # lint:endignore
  selinux::module { 'puppet-proxysql':
    ensure     => present,
    content_fc => "${proxysql::datadir}/proxysql.log* gen_context(system_u:object_r:var_log_t,s0)\n",
    content_te => $content_te,
    builder    => 'refpolicy',
  }
  selinux::exec_restorecon { $proxysql::datadir:
    subscribe => Selinux::Module['puppet-proxysql'],
    require   => File['proxysql-datadir'],
  }
}
