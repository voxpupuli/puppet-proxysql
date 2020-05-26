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
#   The directory where ProxySQL will store its data. Defaults to '/var/lib/proxysql'
#
# * `datadir_mode`
#   The filesystem mode for the `datadir`. Defaults to '0600'
#
# * `manage_selinux`
#   Whether to create the required selinux rules for logrotate to work.  Defaults to `true`, but is only applicable to systems where SELinux is active (`enforcing` or `permissive`).
#   This parameter also requires the `puppet/selinux` module to be installed.
#
# * `manage_mysql_client`
#   Whether to include the mysql::client class. Defaults to `true`
#   You may have mysql::client included or managed with different parameters elsewhere in your catalogue.
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
#   Determines whether this module will configure the ProxySQL configuration file. Defaults to 'true'
#
# * `mycnf_file_name`
#   Path of the my.cnf file where the connections details for the admin interface is save. This is required for the providers to work.
#   This will only be configured if `manage_mycnf_file` is set to `true`. Defaults to '/root/.my.cnf'
#
# * `manage_mycnf_file`
#   Determines whether this module will configure the my.cnf file to connect to the admin interface.
#   This is required for the providers to work. Defaults to 'true'
#
# * `restart`
#   Determines whether this module will restart ProxySQL after reconfiguring the config file. Defaults to 'false'
#
# * `load_to_runtime`
#   Specifies whether te managed ProxySQL resources should be immediately loaded to the active runtime. Boolean, defaults to 'true'.
#
# * `save_to_disk`
#   Specifies whether te managed ProxySQL resources should be immediately save to disk. Boolean, defaults to 'true'.
#
# * `manage_repo`
#   Determines whether this module will manage the repositories where ProxySQL might be. Defaults to 'true'
#
# * `version`
#   The version of proxysql being managed.  This parameter affects the repository configured when `manage_repo == true` and how the service is managed.
#   It does not affect the package version being installed.  It is used as a hint to the puppet module on how to configure proxysql. To control the exact version
#   deployed, use `package_name` or `package_source`.  Defaults to the version currently installed, or `2.0.7` if the `proxysql_version` fact is not yet
#   available.
#
# * `package_source`
#   location of a proxysql package.  When specified, this package will be installed with the `package\_provider` and the `manage_repo` setting will be ignored.
#   Since version 4 of this module, this defaults to `undef` and needs to be specified when you don't want to use a package from a repository.
#
# * `package_provider`
#   provider for `package_source`. defaults to `dpkg` for debian-based, and `rpm` for redhat systems.
#
# * `package_checksum_value`
#   The checksum of the package. Optional and only applicable when `package_source` is provided.
#
# * `package_checksum_type`
#   The 'type' of `package_checksum_value`. Optional and only applicable when `package_checksum_value` is provided.
#
# * `sys_owner`
#   owner of the datadir and config_file, defaults to root or proxysql depending on `version`
#
# * `sys_group`
#   group of the datadir and config_file, defaults to root or proxysql depending on `version`
#
# * `override_config_settings`
#   Which configuration variables should be overriden. Hash, defaults to {} (empty hash).
#
# * `cluster_name`
#   If set, proxysql_servers with the same cluster_name will be automatically added to the same cluster and will
#   synchronize their configuration parameters. Defaults to undef
#
# * `cluster_username`
#   The username ProxySQL will use to connect to the configured mysql_clusters
#   Defaults to 'cluster'
#
# * `cluster_password`
#   The password ProxySQL will use to connect to the configured mysql_clusters. Defaults to 'cluster'
#
# * `mysql_client_package_name`
#   The name of the mysql client package in your package manager. Defaults to undef
#
# * `manage_hostgroup_for_servers`
#   Determines whether this module will manage hostgroup_id for mysql_servers.
#   If false - it will skip difference in this value between manifest and defined in ProxySQL. Defaults to 'true'
#
# * `mysql_servers`
#   Array of mysql_servers, that will be created in ProxySQL. Defaults to undef
#
# * `mysql_users`
#   Array of mysql_users, that will be created in ProxySQL. Defaults to undef
#
# * `mysql_hostgroups`
#   Array of mysql_hostgroups, that will be created in ProxySQL. Defaults to undef
#
# * `mysql_rules`
#   Array of mysql_rules, that will be created in ProxySQL. Defaults to undef
#
# * `schedulers`
#   Array of schedulers, that will be created in ProxySQL. Defaults to undef
#
# * `split_config`
#   If set, ProxySQL config file will be split in 2: main config file with admin and mysql variables
#   and proxy config file with servers\users\hostgroups\scheduler params. Defaults to false
#
# * `proxy_config_file`
#   The file where servers\users\hostgroups\scheduler\rules params of ProxySQL configuration are saved
#   This will only be configured if `split_config` is set to `true`. Defaults to 'proxysql_proxy.cnf'
#
# * `manage_proxy_config_file`
#   Determines whether this module will update the ProxySQL proxy configuration file. Defaults to 'true'
#
class proxysql (
  Optional[String[1]] $cluster_name = $proxysql::params::cluster_name,
  String $package_name = $proxysql::params::package_name,
  Optional[String] $mysql_client_package_name = $proxysql::params::mysql_client_package_name,
  String $package_ensure = $proxysql::params::package_ensure,
  Array[String] $package_install_options = $proxysql::params::package_install_options,
  String $service_name = $proxysql::params::service_name,
  String $service_ensure = $proxysql::params::service_ensure,

  String $datadir = $proxysql::params::datadir,
  Stdlib::Filemode $datadir_mode = $proxysql::params::datadir_mode,
  Boolean $manage_selinux = true,
  Boolean $manage_mysql_client = true,

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

  Boolean $split_config = $proxysql::params::split_config,

  String $proxy_config_file = $proxysql::params::proxy_config_file,
  Boolean $manage_proxy_config_file = $proxysql::params::manage_proxy_config_file,

  String $config_file = $proxysql::params::config_file,
  Boolean $manage_config_file = $proxysql::params::manage_config_file,

  String $mycnf_file_name = $proxysql::params::mycnf_file_name,
  Boolean $manage_mycnf_file = $proxysql::params::manage_mycnf_file,

  Boolean $restart = $proxysql::params::restart,

  Boolean $load_to_runtime = $proxysql::params::load_to_runtime,
  Boolean $save_to_disk = $proxysql::params::save_to_disk,

  Boolean $manage_repo = true,
  Pattern[/^[1|2]\.\d+\.\d+/] $version = $proxysql::params::version,

  Optional[String[1]] $package_source         = undef,
  Optional[String[1]] $package_checksum_value = undef,
  Optional[String[1]] $package_checksum_type  = undef,
  Array[String[1]]    $package_dependencies   = $proxysql::params::package_dependencies,
  Enum['dpkg','rpm']  $package_provider       = $proxysql::params::package_provider,

  String $sys_owner = $version ? {
    /^1/ => 'root',
    /^2/ => 'proxysql',
  },
  String $sys_group = $sys_owner,

  String $cluster_username = $proxysql::params::cluster_username,
  Sensitive[String] $cluster_password = $proxysql::params::cluster_password,

  Hash $override_config_settings = {},

  String $node_name = "${facts['networking']['fqdn']}:${admin_listen_port}",
  Boolean $manage_hostgroup_for_servers = $proxysql::params::manage_hostgroup_for_servers,
  Optional[Proxysql::Server] $mysql_servers = undef,
  Optional[Proxysql::User] $mysql_users = undef,
  Optional[Proxysql::Hostgroup] $mysql_hostgroups = undef,
  Optional[Proxysql::GroupReplicationHostgroup] $mysql_group_replication_hostgroups = undef,
  Optional[Proxysql::GaleraHostgroup] $mysql_galera_hostgroups = undef,
  Optional[Proxysql::Rule] $mysql_rules = undef,
  Optional[Proxysql::Scheduler] $schedulers = undef,
) inherits proxysql::params {

  $default_settings = {
    datadir => $datadir,
    admin_variables => {
      admin_credentials => "${admin_username}:${admin_password.unwrap}",
      mysql_ifaces      => "${admin_listen_ip}:${admin_listen_port};${admin_listen_socket}",
    },
    mysql_variables => {
      interfaces       => "${listen_ip}:${listen_port};${listen_socket}",
      monitor_username => $monitor_username,
      monitor_password => $monitor_password.unwrap,
    },
    mysql_servers => {},
    mysql_users => {},
    mysql_query_rules => {},
    scheduler => {},
    mysql_replication_hostgroups => {},
    mysql_group_replication_hostgroups => {},
    mysql_galera_hostgroups => {},
  }

  $cluster_settings = $cluster_name ? {
    String  => {
      admin_variables => {
        admin_credentials => "${admin_username}:${admin_password.unwrap};${cluster_username}:${cluster_password.unwrap}",
        cluster_username  => $cluster_username,
        cluster_password  => "${cluster_password.unwrap}",
      },
    },
    default => {},
  }

  $config_settings = deep_merge($default_settings, $cluster_settings, $override_config_settings)

  contain proxysql::prerequisites
  contain proxysql::repo
  contain proxysql::install
  contain proxysql::config
  contain proxysql::service
  contain proxysql::admin_credentials
  contain proxysql::reload_config
  contain proxysql::configure

  if $manage_selinux and extlib::has_module('puppet/selinux') and fact('os.selinux.current_mode') in ['enforcing','permissive'] {
    include proxysql::selinux
  }

  Class['proxysql::prerequisites']
  -> Class['proxysql::repo']
  -> Class['proxysql::install']
  -> Class['proxysql::config']
  -> Class['proxysql::service']
  -> Class['proxysql::admin_credentials']
  -> Class['proxysql::reload_config']
  -> Class['proxysql::configure']

  Class['proxysql::install']
  ~> Class['proxysql::service']

  if $restart {
    Class['proxysql::config']
    ~> Class['proxysql::service']
  }

}
