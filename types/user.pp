# lint:ignore:2sp_soft_tabs
type Proxysql::User = Array[Hash[String, Struct[{ password                         => String[1],
                                                  default_hostgroup                => Integer,
                                                  Optional[active]                 => Boolean,
                                                  Optional[use_ssl]                => Boolean,
                                                  Optional[default_schema]         => String[1],
                                                  Optional[schema_locked]          => Boolean,
                                                  Optional[transaction_persistent] => Boolean,
                                                  Optional[fast_forward]           => Boolean,
                                                  Optional[backend]                => Boolean,
                                                  Optional[frontend]               => Boolean,
                                                  Optional[max_connections]        => Integer, }],1,1]]
# lint:endignore                                                   
