# lint:ignore:2sp_soft_tabs
type Proxysql::User = Array[Hash[String, Struct[{ password                         => String[1],
                                                  default_hostgroup                => Integer,
                                                  Optional[active]                 => Integer,
                                                  Optional[use_ssl]                => Integer,
                                                  Optional[default_schema]         => String[1],
                                                  Optional[schema_locked]          => Integer,
                                                  Optional[transaction_persistent] => Integer,
                                                  Optional[fast_forward]           => Integer,
                                                  Optional[backend]                => Integer,
                                                  Optional[frontend]               => Integer,
                                                  Optional[max_connections]        => Integer, }],1,1]]
# lint:endignore                                                   
