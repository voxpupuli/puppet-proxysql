# @summary Represents a ProxySQL server.
type Proxysql::Server = Array[Hash[String, Struct[{ Optional[port]                => Integer,
  hostgroup_id                  => Integer,
  Optional[status]              => String[1],
  Optional[weight]              => Integer,
  Optional[compression]         => Integer,
  Optional[max_connections]     => Integer,
  Optional[max_replication_lag] => Integer,
  Optional[use_ssl]             => Integer[0,1],
  Optional[max_latency_ms]      => Integer,
Optional[comment]             => String[1], }],1,1]]
