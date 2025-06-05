# @summary Represents an entry in the ProxySQL `mysql_galera_hostgroups` admin table.
type Proxysql::GaleraHostgroup = Array[Hash[String, Struct[{ writer                     => Integer[0],
        backup                     => Integer[0],
        reader                     => Integer[0],
        offline                    => Integer[0],
        Optional[active]           => Integer[0,1],
        Optional[writers]          => Integer[0],
        Optional[writer_is_reader] => Integer[0,2],
Optional[max_transactions] => Integer[0], }],1,1]]
