# @summary Represents a ProxySQL group replication hostgroup.
type Proxysql::GroupReplicationHostgroup = Array[Hash[String, Struct[{ writer                     => Integer,
                                                                       backup                     => Integer,
                                                                       reader                     => Integer,
                                                                       offline                    => Integer,
                                                                       Optional[active]           => Integer[0,1],
                                                                       Optional[writers]          => Integer,
                                                                       Optional[writer_is_reader] => Integer[0,1],
                                                                       Optional[max_transactions] => Integer, }],1,1]]
