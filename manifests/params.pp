# == Class proxysql::params
#
# This class is meant to be called from proxysql.
# It sets variables according to platform.
#
class proxysql::params {
  $use_vault          = true
  $load_to_runtime    = true
  $save_to_disk       = true
  $manage_mycnf_file  = true
  $cluser_name        = ''

  $package_name            = 'proxysql'
  $package_ensure          = 'installed'
  $package_install_options = []

  $service_name   = 'proxysql'
  $service_ensure = 'running'

  case $::operatingsystem {
    'Debian': {
      $package_provider    = 'dpkg'
      $sys_owner           = 'root'
      $sys_group           = 'root'
    }
    'Ubuntu': {
      $package_provider    = 'dpkg'
      $sys_owner           = 'proxysql'
      $sys_group           = 'proxysql'
    }
    'CentOS', 'Fedora', 'Scientific', 'RedHat', 'Amazon', 'OracleLinux': {
      $package_provider    = 'rpm'
      $sys_owner           = 'proxysql'
      $sys_group           = 'proxysql'
    }
    default: {
      $package_provider    = undef
      $sys_owner           = 'root'
      $sys_group           = 'root'
    }
  }

  $datadir         = '/var/lib/proxysql'
  $default_mycnf_file_name = '/root/.my.cnf'
  $admin_users     = [ 'dboperator' ]
   
  # ADMIN VARIABLES
  $admin_listen_ip      = '0.0.0.0'
  $admin_listen_port    = 6032
  $admin_listen_socket  = '/tmp/proxysql_admin.sock'
  $admin_username       = 'admin'
  $admin_password       = 'admin'
  $cluster_username     = 'cluster'
  $web_enabled          = true
  $web_port             = 6080

  # MYSQL VARIABLES
  $listen_ip                     = '127.0.0.1'
  $listen_port                   = 3306
  $listen_socket                 = '/tmp/proxysql.sock'
  $monitor_username              = 'proxysql_monitor'
  $monitor_password              = 'monitor'
  $monitor_writer_is_also_reader = false
  $monitor_enabled               = false
  $free_connections_pct          = 20
  $max_allowed_packet            = 67108864
  $threads                       = 4
  $connect_timeout_server_max    = 10000
  $connect_retries_on_failure    = 10

  $config_settings = {
    datadir => $datadir,
    admin_variables => {
      admin_credentials => "${admin_username}:${admin_password}",
      mysql_ifaces => "${admin_listen_ip}:${admin_listen_port};${admin_listen_socket}",
      web_enabled => $web_enabled,
      web_port => $web_port,
    },
    mysql_variables => {
      interfaces => "${listen_ip}:${listen_port};${listen_socket}",
      monitor_writer_is_also_reader => $monitor_writer_is_also_reader,
      monitor_enabled => $monitor_enabled,
      monitor_username => $monitor_username,
      monitor_password => $monitor_password, 
      free_connections_pct => $free_connections_pct,
      max_allowed_packet => $max_allowed_packet,
      threads => $threads,
      connect_timeout_server_max => $connect_timeout_server_max,
      connect_retries_on_failure => $connect_retries_on_failure,

    },
    mysql_servers => {},
    mysql_users => {},
    mysql_query_rules => {},
    scheduler => {},
    mysql_replication_hostgroups => {},
  }

}
