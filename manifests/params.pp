# == Class proxysql::params
#
# This class is meant to be called from proxysql.
# It sets variables according to platform.
#
class proxysql::params {
  $package_name  = 'proxysql'
  $package_ensure = 'installed'
  $package_install_options = []

  $service_name = 'proxysql'
  $service_ensure = 'running'

  $listen_ip     = '0.0.0.0'
  $listen_port   = 6033
  $listen_socket = '/tmp/proxysql.sock'

  $admin_username      = 'admin'
  $admin_password      = Sensitive('admin')
  $admin_listen_ip     = '0.0.0.0'
  $admin_listen_port   = 6032

  case $::operatingsystem {
    'Debian': {
      $admin_listen_socket = '/tmp/proxysql_admin.sock'
      $package_provider    = 'dpkg'
      $sys_owner           = 'root'
      $sys_group           = 'root'
    }
    'Ubuntu': {
      $admin_listen_socket = '/tmp/proxysql_admin.sock'
      $package_provider    = 'dpkg'
      $sys_owner           = 'proxysql'
      $sys_group           = 'proxysql'
    }
    'CentOS', 'Fedora', 'Scientific', 'RedHat', 'Amazon', 'OracleLinux': {
      $admin_listen_socket = '/tmp/proxysql_admin.sock'
      $package_provider    = 'rpm'
      $sys_owner           = 'proxysql'
      $sys_group           = 'proxysql'
    }
    default: {
      $admin_listen_socket = '/tmp/proxysql_admin.sock'
      $package_provider    = undef
      $sys_owner           = 'root'
      $sys_group           = 'root'
    }
  }

  $monitor_username = 'monitor'
  $monitor_password = Sensitive('monitor')

  $datadir = '/var/lib/proxysql'

  $main_config_file         = '/etc/proxysql.cnf'
  $manage_main_config_file  = true
  $config_directory         = '/etc/proxysql.d/'
  $proxy_config_file        = 'proxysql_proxy.cnf'
  $manage_proxy_config_file = true

  $mycnf_file_name   = '/root/.my.cnf'
  $manage_mycnf_file = true

  $restart = false

  $manage_repo = true

  $load_to_runtime              = true
  $save_to_disk                 = true
  $manage_hostgroup_for_servers = true

  $rpm_repo_name   = 'percona_repo'
  $rpm_repo_descr  = 'percona_repo_contains_proxysql'
  $rpm_repo        = 'http://repo.percona.com/release/$releasever/RPMS/$basearch'
  $rpm_repo_key    = 'https://www.percona.com/downloads/RPM-GPG-KEY-percona'

  $cluster_username = 'cluster'
  $cluster_password = Sensitive('cluster')

  $config_settings = {
   datadir => $datadir,
   admin_variables => {
     admin_credentials => "${admin_username}:${admin_password};",
     mysql_ifaces => "${admin_listen_ip}:${admin_listen_port};${admin_listen_socket}",
   },
   mysql_variables => {
     interfaces => "${listen_ip}:${listen_port};${listen_socket}",
     monitor_username => $monitor_username,
     monitor_password => $monitor_password, 
   },
   mysql_servers => {},
   mysql_users => {},
   mysql_query_rules => {},
   scheduler => {},
   mysql_replication_hostgroups => {},
  }

}
