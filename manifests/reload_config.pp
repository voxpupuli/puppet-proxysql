# == Class proxysql::reload_config
#
# This class is called from proxysql to update config if it changed.
#
class proxysql::reload_config {

  $subscribe = $proxysql::split_config ? {
    true  => [ File['proxysql-config-file'], File['proxysql-proxy-config-file'] ],
    false => File['proxysql-config-file'],
  }

  $mycnf_file_name = $proxysql::mycnf_file_name
    exec {'reload-config':
        command     => "/usr/bin/mysql --defaults-extra-file=${mycnf_file_name} --execute=\"
          LOAD ADMIN VARIABLES FROM CONFIG; \
          LOAD ADMIN VARIABLES TO RUNTIME; \
          SAVE ADMIN VARIABLES TO DISK; \
          LOAD MYSQL VARIABLES FROM CONFIG; \
          LOAD MYSQL VARIABLES TO RUNTIME; \
          SAVE MYSQL VARIABLES TO DISK; \"
        ",
        subscribe   => $subscribe,
        require     => [ Service[$proxysql::service_name] , File['root-mycnf-file'] ],
        refreshonly => true,
    }
}
