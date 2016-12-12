# == Class proxysql::params
#
# This class is meant to be called from proxysql.
# It sets variables according to platform.
#
class proxysql::params {
  $package_name = 'proxysql'
  $service_name = 'proxysql'

  $listen_ip     = '0.0.0.0'
  $listen_port   = 6033
  $listen_socket = '/tmp/proxysql.sock'

  $admin_username      = 'admin'
  $admin_password      = 'admin'
  $admin_listen_ip     = '127.0.0.1'
  $admin_listen_port   = 6032
  $admin_listen_socket = '/tmp/proxysql_admin.sock'

  $monitor_username = 'monitor'
  $monitor_password = 'monitor'

  $datadir = '/var/lib/proxysql'

  $config_file        = '/etc/proxysql.cnf'
  $manage_config_file = true

  $mycnf_file_name   = '/root/.my.cnf'
  $manage_mycnf_file = true

  $config_settings = {
    datadir => $datadir,
    admin_variables => {
      admin_credentials => "${admin_username}:${admin_password}",
      mysql_ifaces => "${admin_listen_ip}:${admin_listen_port};${admin_listen_socket}",
      refresh_interval => 2000,
    },
    mysql_variables => {
      threads => 4,
      max_connections => 2048,
      default_query_delay => 0,
      default_query_timeout => 36000000,
      have_compress => true,
      poll_timeout => 2000,
      interfaces => "${listen_ip}:${listen_port};${listen_socket}",
      default_schema => 'information_schema',
      stacksize => 1048576,
      server_version => '5.5.30',
      connect_timeout_server => 3000,
      monitor_history => 600000,
      monitor_connect_interval => 60000,
      monitor_ping_interval => 10000,
      monitor_read_only_interval => 1500,
      monitor_read_only_timeout => 500,
      ping_interval_server => 120000,
      ping_timeout_server => 500,
      commands_stats => true,
      sessions_sort => true,
      connect_retries_on_failure => 10,
    },
    mysql_servers => {},
    mysql_users => {},
    mysql_query_rules => {},
    scheduler => {},
    mysql_replication_hostgroups => {},
  }
}
