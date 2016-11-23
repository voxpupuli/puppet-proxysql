# Class: proxysql
# ===========================
#
# Full description of class proxysql here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class proxysql (
  String $package_name = $::proxysql::params::package_name,
  String $service_name = $::proxysql::params::service_name,

  String $datadir = $::proxysql::params::datadir,

  String $listen_ip = $::proxysql::params::listen_ip,
  Integer $listen_port = $::proxysql::params::listen_port,
  String $listen_socket = $::proxysql::params::listen_socket,

  String $admin_username = $::proxysql::params::admin_username,
  String $admin_password = $::proxysql::params::admin_password,
  String $admin_listen_ip = $::proxysql::params::admin_listen_ip,
  Integer $admin_listen_port = $::proxysql::params::admin_listen_port,
  String $admin_listen_socket = $::proxysql::params::admin_listen_socket,

  String $monitor_username = $::proxysql::params::monitor_username,
  String $monitor_password = $::proxysql::params::monitor_password,

  String $config_file = $::proxysql::params::config_file,
  Boolean $manage_config_file = $::proxysql::params::manage_config_file,

  String $mycnf_file_name = $::proxysql::params::mycnf_file_name,
  Boolean $manage_mycnf_file = $::proxysql::params::manage_mycnf_file,

  Hash $override_config_settings = {},
) inherits ::proxysql::params {

  # lint:ignore:80chars
  $settings = {
    datadir => $datadir,
    admin_variables => {
      admin_credentials => "${admin_username}:${admin_password}",
      mysql_ifaces => "${admin_listen_ip}:${admin_listen_port};${admin_listen_socket}",
    },
    mysql_variables => {
      interfaces       => "${listen_ip}:${listen_port};${listen_socket}",
      monitor_username => $monitor_username,
      monitor_password => $monitor_password,
    }
  }
  $config_settings = deep_merge($proxysql::params::config_settings, $override_config_settings, $settings)
  # lint:endignore

  class { '::proxysql::install': } ->
  class { '::proxysql::config': } ~>
  class { '::proxysql::service': } ->
  Class['::proxysql']
}
