# lint:ignore:80chars
# lint:ignore:2sp_soft_tabs
# variant 1

class { 'proxysql':
  mysql_servers                      => [ { 'db1' => { 'port'         => 3306,
                                                       'hostgroup_id' => 1, } },
                                          { 'db2' => { 'hostgroup_id' => 2, } },
  ],
  mysql_users                        => [ { 'app' => { 'password'          => '*92C74DFBDA5D60ABD41EFD7EB0DAE389F4646ABB',
                                                       'default_hostgroup' => 1, } },
                                          { 'ro'  => { 'password'          => '*86935F2843252CFAAC4CE713C0D5FF80CF444F3B',
                                                       'default_hostgroup' => 2, } },
  ],
  mysql_hostgroups                   => [ { 'hostgroup 1' => { 'writer' => 1,
                                                               'reader' => 2, } },
  ],
  mysql_group_replication_hostgroups => [ { 'hostgroup 2' => { 'reader'  => 10,
                                                               'writer'  => 5,
                                                               'backup'  => 2,
                                                               'offline' => 11, } },
  ],
  mysql_galera_hostgroups            => [ { 'hostgroup 2' => { 'reader'  => 10,
                                                               'writer'  => 5,
                                                               'backup'  => 2,
                                                               'offline' => 11, } },
  ],
  mysql_rules                        => [ { 'testable to test DB' => { 'rule_id'         => 1,
                                                                       'match_pattern'   => 'testtable',
                                                                       'replace_pattern' => 'test.newtable',
                                                                       'apply'           => 1,
                                                                       'active'          => 1, } },
  ],
  schedulers                         => [ { 'test scheduler' => { 'scheduler_id' => 1,
                                                                  'active'       => 0,
                                                                  'filename'     => '/usr/bin/whoami', } },
  ],
}
# lint:endignore

# variant 2

class { 'proxysql':
  listen_port    => 3306,
  admin_password => 'SuperSecretPassword',
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

proxy_mysql_group_replication_hostgroup { '5-2-10-11':
  reader_hostgroup        => 10,
  writer_hostgroup        => 5,
  backup_writer_hostgroup => 2,
  offline_hostgroup       => 11,
}

proxy_mysql_galera_hostgroup { '1-2-3-4':
  writer_hostgroup        => 1,
  backup_writer_hostgroup => 2,
  reader_hostgroup        => 3,
  offline_hostgroup       => 4,
  comment                 => 'Galera Replication Group 1',
}
proxy_mysql_galera_hostgroup { '5-6-7-8':
  writer_hostgroup        => 5,
  backup_writer_hostgroup => 6,
  reader_hostgroup        => 7,
  offline_hostgroup       => 8,
  comment                 => 'Galera Replication Group 2',
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
