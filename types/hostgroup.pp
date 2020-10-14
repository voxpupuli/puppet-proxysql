# @summary Represents a ProxySQL replication hostgroup.
type Proxysql::Hostgroup = Array[Hash[String, Struct[{ writer => Integer,
                                                       reader => Integer, }],1,1]]
