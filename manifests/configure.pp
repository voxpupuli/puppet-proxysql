# == Class proxysql::configure
#
# This class is called from proxysql for all proxy configuration.
#
class proxysql::configure {

  if $proxysql::mysql_servers {
    $proxysql::mysql_servers.each |$server| {
      $server.each |$k,$v| {
        $hostname = $k
        $port = $server[$k][port] ? { undef   => 3306,
                                      default => $server[$k][port], }
        $hostgroup_id = $server[$k][hostgroup_id]

        if $proxysql::manage_hostgroup_for_servers {
          proxy_mysql_server { "${hostname}:${port}-${hostgroup_id}":
            hostname => $hostname,
            *        => $server[$k],
          }
        } else {
          proxy_mysql_server_no_hostgroup { "${hostname}:${port}":
            hostname => $hostname,
            *        => $server[$k],
          }
        }
      }
    }
  }

  if $proxysql::mysql_users {
    $proxysql::mysql_users.each |$user| {
      $user.each |$k,$v| {
        $username = $k

        proxy_mysql_user { $username:
          * => $user[$k],
        }
      }
    }
  }

  if $proxysql::mysql_hostgroups {
    $proxysql::mysql_hostgroups.each |$hostgroup| {
      $hostgroup.each |$k,$v| {
        $comment = $k
        $reader = $hostgroup[$k][reader]
        $writer = $hostgroup[$k][writer]

        proxy_mysql_replication_hostgroup { "${writer}-${reader}":
          writer_hostgroup => $writer,
          reader_hostgroup => $reader,
          comment          => $k,
        }
      }
    }
  }

  if $proxysql::mysql_group_replication_hostgroups {
    $proxysql::mysql_group_replication_hostgroups.each |$hostgroup| {
      $hostgroup.each |$k,$v| {
        $comment          = $k
        $reader           = $hostgroup[$k][reader]
        $backup           = $hostgroup[$k][backup]
        $writer           = $hostgroup[$k][writer]
        $offline          = $hostgroup[$k][offline]
        $active           = $hostgroup[$k][active]
        $writers          = $hostgroup[$k][writers]
        $writer_is_reader = $hostgroup[$k][writer_is_reader]
        $max_transactions = $hostgroup[$k][max_transactions]

        proxy_mysql_group_replication_hostgroup { "${writer}-${backup}-${reader}-${offline}":
          writer_hostgroup        => $writer,
          backup_writer_hostgroup => $backup,
          reader_hostgroup        => $reader,
          offline_hostgroup       => $offline,
          active                  => $active,
          max_writers             => $writers,
          writer_is_also_reader   => $writer_is_reader,
          max_transactions_behind => $max_transactions,
          comment                 => $k,
        }
      }
    }
  }

  if $proxysql::mysql_galera_hostgroups {
    $proxysql::mysql_galera_hostgroups.each |$hostgroup| {
      $hostgroup.each |$k,$v| {
        $comment          = $k
        $reader           = $hostgroup[$k][reader]
        $backup           = $hostgroup[$k][backup]
        $writer           = $hostgroup[$k][writer]
        $offline          = $hostgroup[$k][offline]
        $active           = $hostgroup[$k][active]
        $writers          = $hostgroup[$k][writers]
        $writer_is_reader = $hostgroup[$k][writer_is_reader]

        proxy_mysql_galera_hostgroup { "${writer}-${backup}-${reader}-${offline}":
          writer_hostgroup        => $writer,
          backup_writer_hostgroup => $backup,
          reader_hostgroup        => $reader,
          offline_hostgroup       => $offline,
          active                  => $active,
          max_writers             => $writers,
          writer_is_also_reader   => $writer_is_reader,
          comment                 => $k,
        }
      }
    }
  }

  if $proxysql::mysql_rules {
    $proxysql::mysql_rules.each |$rule| {
      $rule.each |$k,$v| {
        $comment = $k
        $rule_id = $rule[$k][rule_id]

        proxy_mysql_query_rule { "mysql_query_rule-${rule_id}":
          comment => $k,
          *       => $rule[$k],
        }
      }
    }
  }

  if $proxysql::schedulers {
    $proxysql::schedulers.each |$scheduler| {
      $scheduler.each |$k,$v| {
        $comment = $k
        $scheduler_id = $scheduler[$k][scheduler_id]

        proxy_scheduler { "scheduler-${scheduler_id}":
          comment => $k,
          *       => $scheduler[$k],
        }
      }
    }
  }
}

