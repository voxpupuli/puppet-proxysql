# lint:ignore:80chars
exec { 'ugent-keyring':
  command => 'wget http://debs.ugent.be/debian/pool/main/u/ugent-keyring/ugent-keyring_0.2-2_all.deb && dpkg -i ugent-keyring_0.2-2_all.deb && apt-get update',
  cwd     => '/root',
  creates => '/root/ugent-keyring_0.2-2_all.deb',
  path    => ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin','/opt/puppetlabs/bin'],
  unless  => 'test -f /root/ugent-keyring_0.2-2_all.deb',
}->
apt::source{ 'debs_jessie_mysql_dev':
  comment  => 'MySQL-dev repo',
  location => 'http://debs.ugent.be/debian',
  repos    => 'mysql-dev',
}->
class { '::proxysql':
  listen_port    => 3306,
  admin_password => '123456',
}
# lint:endignore
