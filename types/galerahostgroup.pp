# lint:ignore:2sp_soft_tabs
type Proxysql::GaleraHostgroup = Array[Hash[String, Struct[{ writer                     => Integer,
                                                             backup                     => Integer,
                                                             reader                     => Integer,
                                                             offline                    => Integer,
                                                             Optional[active]           => Integer[1],
                                                             Optional[writers]          => Integer,
                                                             Optional[writer_is_reader] => Integer[1],
                                                             Optional[max_transactions] => Integer, }],1,1]]
# lint:endignore
