# == Class proxysql::service
#
# This class is meant to be called from proxysql.
# It ensure the service is running.
#
class proxysql::service {
  assert_private()

  # systemd unit files replaced use of `init.d` in version 2.0.0 for some operating systems but only in 2.0.7 for CentOS/Redhat
  if (versioncmp($proxysql::version, '2.0.7') >= 0 and fact('os.family') == 'RedHat' and fact('os.name') != 'Amazon' and versioncmp(fact('os.release.major'),'7') >= 0)
  or (versioncmp($proxysql::version, '2')     >= 0 and fact('os.name')   == 'Ubuntu' and versioncmp(fact('os.release.major'),'18.04') >= 0)
  or (versioncmp($proxysql::version, '2')     >= 0 and fact('os.name')   == 'Debian' and versioncmp(fact('os.release.major'),'9')     >= 0)
  {
    $drop_in_ensure = $proxysql::restart ? {
      true  => 'present',
      false => 'absent',
    }
    systemd::dropin_file { 'proxysql ExecStart override':
      ensure   => $drop_in_ensure,
      filename => 'puppet.conf',
      unit     => "${proxysql::service_name}.service",
      content  => "[Service]\nExecStart=\nExecStart=/usr/bin/proxysql --reload -c /etc/proxysql.cnf\n",
      notify   => Service[$proxysql::service_name],
    }
    service { $proxysql::service_name:
      ensure => $proxysql::service_ensure,
      enable => true,
    }
  } else {
    if $proxysql::restart {
      if versioncmp($proxysql::version, '2') >= 0 and fact('os.family') == 'RedHat' {
        # In proxysql version 2, the init.d scripts, (EL6 and EL7 with proxysql < 2.0.7) support a `reload` option.
        # Use this instead of `/usr/bin/proxysql --reload`, (which will run as root).
        $start = '/etc/init.d/proxysql reload'
      } else {
        $start = '/usr/bin/proxysql --reload'
      }
      service { $proxysql::service_name:
        ensure     => $proxysql::service_ensure,
        enable     => true,
        hasstatus  => true,
        hasrestart => false,
        provider   => 'base',
        status     => '/etc/init.d/proxysql status',
        start      => $start,
        stop       => '/etc/init.d/proxysql stop',
      }
    } else {
      service { $proxysql::service_name:
        ensure     => $proxysql::service_ensure,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
      }
    }
  }

  exec { 'wait_for_admin_socket_to_open':
    command   => "test -S ${proxysql::admin_listen_socket}",
    unless    => "test -S ${proxysql::admin_listen_socket}",
    tries     => '3',
    try_sleep => '10',
    require   => Service[$proxysql::service_name],
    path      => '/bin:/usr/bin',
  }

}
