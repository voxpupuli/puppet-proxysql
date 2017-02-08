# lint:ignore:80chars

class { '::proxysql':
  listen_port    => 3306,
  admin_password => 'SuperSecretPassword',
  repo           => {
    'debs_proxysql_repo' => {
      comment  => 'ProxySQL repo',
      location => 'http://debs.ugent.be/debian',
      repos    => 'mysql-dev',
    },
  },
}

proxy_mysql_server { '192.168.33.31:3306-31':
  hostname     => '192.168.33.31',
  port         => 3306,
  hostgroup_id => 31,
}
proxy_mysql_server { '192.168.33.32:3306-31':
  hostname     => '192.168.33.32',
  port         => 3306,
  hostgroup_id => 31,
}
proxy_mysql_server { '192.168.33.33:3306-31':
  hostname     => '192.168.33.33',
  port         => 3306,
  hostgroup_id => 31,
}
proxy_mysql_server { '192.168.33.34:3306-31':
  hostname     => '192.168.33.34',
  port         => 3306,
  hostgroup_id => 31,
}
proxy_mysql_server { '192.168.33.35:3306-31':
  hostname     => '192.168.33.35',
  port         => 3306,
  hostgroup_id => 31,
}

proxy_mysql_replication_hostgroup { '30-31':
  writer_hostgroup => 30,
  reader_hostgroup => 31,
  comment          => 'Replication Group 1',
}
proxy_mysql_replication_hostgroup { '20-21':
  writer_hostgroup => 20,
  reader_hostgroup => 21,
  comment          => 'Replication Group 2',
}

proxy_mysql_user { 'tester':
  password          => 'testerpwd',
  default_hostgroup => 30,
}

proxy_mysql_query_rule { 'mysql_query_rule-1':
  rule_id               => 1,
  match_pattern         => '^SELECT',
  apply                 => 1,
  active                => 1,
  destination_hostgroup => 31,
}

proxy_scheduler { 'scheduler-1':
  scheduler_id => 1,
  active       => 0,
  filename     => '/usr/bin/whoami',
}

proxy_scheduler { 'scheduler-2':
  scheduler_id => 2,
  active       => 0,
  interval_ms  => 1000,
  filename     => '/usr/bin/id',
}
# lint:endignore
