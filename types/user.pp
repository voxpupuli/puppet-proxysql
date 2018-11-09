# lint:ignore:2sp_soft_tabs
type Proxysql::User = Array[Hash[String, Struct[{ password                         => String[1],
                                                  default_hostgroup                => Integer,
                                                  Optional[active]                 => Integer[0,1],
                                                  Optional[use_ssl]                => Integer[0,1],
                                                  Optional[default_schema]         => String[1],
                                                  Optional[schema_locked]          => Integer[0,1],
                                                  Optional[transaction_persistent] => Integer[0,1],
                                                  Optional[fast_forward]           => Integer[0,1],
                                                  Optional[backend]                => Integer[0,1],
                                                  Optional[frontend]               => Integer[0,1],
                                                  Optional[max_connections]        => Integer, }],1,1]]
# lint:endignore
