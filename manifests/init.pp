# Class: proxysql
# ===========================
#
# Full description of class proxysql here.
#
# Parameters
# ----------
#
# * `package_name`
#   The name of the ProxySQL package in your package manager. Defaults to 'proxysql'
#
# * `package_ensure`
#   The ensure of the ProxySQL package resource. Defaults to 'installed'
#
# * `service_name`
#   The name of the ProxySQL service resource. Defaults to 'proxysql'
#
# * `service_ensure`
#   The ensure of the ProxySQL service resource. Defaults to 'running'
#
# * `datadir`
#   The directory where ProxySQL will store it's data. defaults to '/var/lib/proxysql'
#
# * `listen_ip`
#   The ip where the ProxySQL service will listen on. Defaults to '0.0.0.0' aka all configured IP's on the machine
#
# * `listen_port`
#   The port where the ProxySQL service will listen on. Defaults to '6033'
#
# * `listen_socket`
#   The socket where the ProxySQL service will listen on. Defaults to '/tmp/proxysql.sock'
#
# * `admin_username`
#   The username to connect to the ProxySQL admin interface. Defaults to 'admin'
#
# * `admin_password`
#   The password to connect to the ProxySQL admin interface. Defaults to 'admin'
#
# * `admin_listen_ip`
#   The ip where the ProxySQL admin interface will listen on. Defaults to '127.0.0.1'
#
# * `admin_listen_port`
#   The port where the ProxySQL admin interface  will listen on. Defaults to '6032'
#
# * `admin_listen_socket`
#   The socket where the ProxySQL admin interface  will listen on. Changing this on a running system will result in failing runs.
#   Defaults to '/tmp/proxysql_admin.sock'
#
# * `monitor_username`
#   The username ProxySQL will use to connect to the configured mysql_servers. Defaults to 'monitor'
#
# * `monitor_password`
#   The password ProxySQL will use to connect to the configured mysql_servers. Defaults to 'monitor'
#
# * `config_file`
#   The file where the ProxySQL configuration is saved. This will only be configured if `manage_config_file` is set to `true`.
#   Defaults to '/etc/proxysql.cnf'
#
# * `manage_config_file`
#   Determines wheter this module will configure the ProxySQL configuration file. Defaults to 'true'
#
# * `mycnf_file_name`
#   Path of the my.cnf file where the connections details for the admin interface is save. This is required for the providers to work.
#   This will only be configured if `manage_mycnf_file` is set to `true`. Defaults to '/root/.my.cnf'
#
# * `manage_mycnf_file`
#   Determines wheter this module will configure the my.cnf file to connect to the admin interface.
#   This is required for the providers to work. Defaults to 'true'
#
# * `restart`
#   Determines wheter this module will restart ProxySQL after reconfiguring the config file. Defaults to 'false'
#
# * `load_to_runtime`
#   Specifies wheter te managed ProxySQL resources should be immediately loaded to the active runtime. Boolean, defaults to 'true'.
#
# * `save_to_disk`
#   Specifies wheter te managed ProxySQL resources should be immediately save to disk. Boolean, defaults to 'true'.
#
# * `manage_repo`
#   Determines wheter this module will manage the repositories where ProxySQL might be. Defaults to 'true'
#
# * `repo`
#   These are the repo's we will configure. Currently only Debian is supported. This hash will be passed on
#   to `apt::source` or `yumrepo` (depending on the OS family).
#   Defaults to the official upstream repo for your OS. See http://repo.proxysql.com for more info.
#
# * `package_source`
#   location ot the proxysql package for the `package_provider`.
#   Default to 'https://github.com/sysown/proxysql/releases/download/v1.4.7/proxysql-1.4.7-1-centos7.x86_64.rpm' for RedHat based systems
#   Default to 'https://github.com/sysown/proxysql/releases/download/v1.4.7/proxysql_1.4.7-ubuntu16_amd64.deb' for Debian based systems
#
# * `package_provider`
#   provider for package-resource. defaults to `dpkg` for debian-based, `rpm` for redhat base or undef for others
#
# * `sys_owner`
#   owner of the datadir and config_file, defaults to root.
#
# * `sys_group`
#   group of the datadir and config_file, defaults to root.
#
# * `override_config_settings`
#   Which configuration variables should be overriden. Hash, defaults to {} (empty hash).
#
# * `cluster_name`
#   If set, proxysql_servers with the same cluster_name will be automatically added to the same cluster and will 
#   synchronize their configuration parameters. Defaults to ''
#
# * `cluster_username`
#   The username ProxySQL will use to connect to the configured mysql_clusters
#   Defaults to 'cluster'
#
# * `cluster_password`
#   The password ProxySQL will use to connect to the configured mysql_clusters. Defaults to 'cluster'
#
# * `mysql_client_package_name`
#   The name of the mysql client package in your package manager. Defaults to ''
#
class proxysql (
  String $cluster_name = $proxysql::params::cluster_name,
  String $package_name = $proxysql::params::package_name,
  String $mysql_client_package_name = $proxysql::params::mysql_client_package_name,
  String $package_ensure = $proxysql::params::package_ensure,
  Array[String] $package_install_options = $proxysql::params::package_install_options,
  String $service_name = $proxysql::params::service_name,
  String $service_ensure = $proxysql::params::service_ensure,

  String $datadir = $proxysql::params::datadir,

  String $listen_ip = $proxysql::params::listen_ip,
  Integer $listen_port = $proxysql::params::listen_port,
  String $listen_socket = $proxysql::params::listen_socket,

  String $admin_username = $proxysql::params::admin_username,
  Sensitive[String] $admin_password = $proxysql::params::admin_password,
  String $admin_listen_ip = $proxysql::params::admin_listen_ip,
  Integer $admin_listen_port = $proxysql::params::admin_listen_port,
  String $admin_listen_socket = $proxysql::params::admin_listen_socket,

  String $monitor_username = $proxysql::params::monitor_username,
  Sensitive[String] $monitor_password = $proxysql::params::monitor_password,

  String $config_file = $proxysql::params::config_file,
  Boolean $manage_config_file = $proxysql::params::manage_config_file,

  String $mycnf_file_name = $proxysql::params::mycnf_file_name,
  Boolean $manage_mycnf_file = $proxysql::params::manage_mycnf_file,

  Boolean $restart = $proxysql::params::restart,

  Boolean $load_to_runtime = $proxysql::params::load_to_runtime,
  Boolean $save_to_disk = $proxysql::params::save_to_disk,

  Boolean $manage_repo = true,
  Hash $repo = $proxysql::params::repo,

  String $package_source = $proxysql::params::package_source,
  String $package_checksum_value = $proxysql::params::package_checksum_value,
  String $package_checksum_type = $proxysql::params::package_checksum_type,
  Array $package_dependencies = $proxysql::params::package_dependencies,
  String $package_provider= $proxysql::params::package_provider,

  String $sys_owner = $proxysql::params::sys_owner,
  String $sys_group = $proxysql::params::sys_group,

  String $cluster_username = $::proxysql::params::cluster_username,
  Sensitive[String] $cluster_password = $::proxysql::params::cluster_password,

  Hash $override_config_settings = {},

  String $node_name = "${::fqdn}:${admin_listen_port}",
) inherits ::proxysql::params {

  # lint:ignore:80chars
  $settings = {
    datadir => $datadir,
    admin_variables => {
      admin_credentials => "${admin_username}:${admin_password.unwrap}",
      mysql_ifaces => "${admin_listen_ip}:${admin_listen_port};${admin_listen_socket}",
    },
    mysql_variables => {
      interfaces       => "${listen_ip}:${listen_port};${listen_socket}",
      monitor_username => $monitor_username,
      monitor_password => $monitor_password.unwrap,
    },
  }

  if $cluster_name != '' {
    $settings_cluster = {
      admin_variables => {
        admin_credentials => "${admin_username}:${admin_password.unwrap};${cluster_username}:${cluster_password.unwrap}",
        cluster_username => $cluster_username,
        cluster_password => "${cluster_password.unwrap}",
      },
    }
  } else {
      $settings_cluster = ''
    }

  $settings_result = deep_merge($settings, $settings_cluster)

  $config_settings = deep_merge($proxysql::params::config_settings, $settings_result, $override_config_settings)
  # lint:endignore

  anchor { '::proxysql::begin': }
  -> class { '::proxysql::repo':}
  -> class { '::proxysql::install':}
  -> class { '::proxysql::config':}
  -> class { '::proxysql::service':}
  -> class { '::proxysql::admin_credentials':}
  -> anchor { '::proxysql::end': }

  Class['::proxysql::install']
  ~> Class['::proxysql::service']

  if $restart {
    Class['::proxysql::config']
    ~> Class['::proxysql::service']
  }

}
