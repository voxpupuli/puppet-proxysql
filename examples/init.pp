# lint:ignore:80chars
apt::source{ 'debs_jessie_mysql_dev':
  comment  => 'MySQL-dev repo',
  location => 'http://debs.ugent.be/debian',
  repos    => 'mysql-dev',
}->
class { '::proxysql':
  listen_port              => 3306,
  admin_password           => 'SuperSecretPassword',
  override_config_settings => {
    mysql_servers                => {
      'mysql1' => {
        address   => '192.168.33.31',
        port      => 3306,
        hostgroup => 31,
      },
      'mysql2' => {
        address   => '192.168.33.32',
        port      => 3306,
        hostgroup => 31,
      },
      'mysql3' => {
        address   => '192.168.33.33',
        port      => 3306,
        hostgroup => 31,
      },
      'mysql4' => {
        address   => '192.168.33.34',
        port      => 3306,
        hostgroup => 31,
      },
      'mysql5' => {
        address   => '192.168.33.35',
        port      => 3306,
        hostgroup => 31,
      },
    },
    mysql_replication_hostgroups => {
      'hostgroup1' => {
        writer_hostgroup => 30,
        reader_hostgroup => 31,
        comment          => 'Replication Group 1',
      },
      'hostgroup2' => {
        writer_hostgroup => 20,
        reader_hostgroup => 21,
        comment          => 'Replication Group 2',
      },
    }
  }
}
# lint:endignore
