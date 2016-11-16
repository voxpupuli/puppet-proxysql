# lint:ignore:80chars
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
