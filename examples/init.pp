# lint:ignore:80chars
class { '::proxysql':
  cluster_name => 'cluster11',
  mysql_servers => [ { 'db1' => { 'port' => 3306,
                                  'hostgroup_id' => 1, } },  # HERE hostgroup_id = 1 is writer
                     { 'db2' => { 'hostgroup_id' => 2, } }   # HERE hosgroup_id = 2 is reader
  ],
  mysql_users => [ { 'app' => { 'password'          => '*92C74DFBDA5D60ABD41EFD7EB0DAE389F4646ABB',
                                'default_hostgroup' => 1, } },   # this is a login, which is used by our application to connect to master (notice default_hostgroup = 1)
                   { 'ro'  => { 'password'          => '*86935F2843252CFAAC4CE713C0D5FF80CF444F3B',
                                'default_hostgroup' => 2, } }    # this is a login, which is used to connect to slave (notice default_hostgroup = 2)
  ],
  mysql_rules => [ { 'wgInvoices to invoices DB' => { 'rule_id'               => 1,
                                                      'match_pattern'         => 'testtable',
                                                      'replace_pattern'       => 'test.newtable',
                                                      'apply'                 => 1,
                                                      'active'                => 1, } }  # this query rule will find all queries with text testtable and replace them with test.newtable. 
  ],                                                                                      # Used to move tables to another database without modifying application.
  schedulers => [ { 'test scheduler' => { 'scheduler_id'  => 1,
                                               'active'   => 0,
                                               'filename' => '/usr/bin/whoami', } }
  ],
}
# lint:endignore
