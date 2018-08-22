type Proxysql::Scheduler = Array[Hash[String, Struct[{ scheduler_id          => Integer,
                                                       active                => Integer, 
                                                       Optional[interval_ms] => Integer,
                                                       filename              => String[1],
                                                       Optional[arg1]        => String[1],
                                                       Optional[arg2]        => String[1],
                                                       Optional[arg3]        => String[1],
                                                       Optional[arg4]        => String[1],
                                                       Optional[arg5]        => String[1] }],1,1]]
