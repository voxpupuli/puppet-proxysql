# lint:ignore:80chars
class { '::proxysql':
  cluster_name => 'cluster11',
  mysql_servers => [ { 'db1' => { 'port' => 3306,
                                  'hostgroup_id' => 1, } },
                     { 'db2' => { 'hostgroup_id' => 2, } }
  ],
  mysql_users => [ { 'app' => { 'password'          => '*92C74DFBDA5D60ABD41EFD7EB0DAE389F4646ABB',
                                'default_hostgroup' => 1, } },
                   { 'ro'  => { 'password'          => '*86935F2843252CFAAC4CE713C0D5FF80CF444F3B',
                                'default_hostgroup' => 2, } }
  ],
  mysql_hostgroups => [ { 'Replication Group 1' => { 'writer' => 1,
                                                     'reader' => 2, } }
  ],
  mysql_rules => [ { 'wgInvoices to invoices DB' => { 'rule_id'               => 1,
                                                      'match_pattern'         => 'wgInvoices',
                                                      'replace_pattern'       => 'invoices.wgInvoices',
                                                      'apply'                 => 1,
                                                      'active'                => 1,
                                                      'destination_hostgroup' => 1, } }
  ],
  schedulers => [ { 'test scheduler' => { 'scheduler_id'  => 1,
                                               'active'   => 0,
                                               'filename' => '/usr/bin/whoami', } }
  ],
}
# lint:endignore
