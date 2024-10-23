# @summary Install and configure ProxySQL.
#
# @param package_name
#   The name of the ProxySQL package in your package manager.
# @param package_ensure
#   The ensure of the ProxySQL package resource.
# @param package_install_options
#   An array of additional options to pass when installing a package. 
# @param service_name
#   The name of the ProxySQL service resource.
# @param service_ensure
#   The ensure of the ProxySQL service resource.
# @param datadir
#   The directory where ProxySQL will store its data.
# @param datadir_mode
#   The filesystem mode for the `datadir`.
# @param errorlog_file
#   The File where ProxySQL will store its error logs. Available from ProxySQL v2.0.0
# @param errorlog_file_mode
#   The filesystem mode for the `errorlog_file`. Available from ProxySQL v2.0.0
# @param errorlog_file_owner
#   Owner of the `errorlog_file`. Available from ProxySQL v2.0.0
# @param errorlog_file_group
#   Group of the `errorlog_file`. Available from ProxySQL v2.0.0
# @param manage_selinux
#   Whether to create the required selinux rules for logrotate to work. 
#   This parameter also requires the `puppet/selinux` module to be installed.
# @param manage_mysql_client
#   Whether to include the mysql::client class.
#   You may have mysql::client included or managed with different parameters elsewhere in your catalogue.
# @param listen_ip
#   The ip where the ProxySQL service will listen on.
# @param listen_port
#   The port where the ProxySQL service will listen on.
# @param listen_socket
#   The socket where the ProxySQL service will listen on.
# @param admin_username
#   The username to connect to the ProxySQL admin interface.
# @param admin_password
#   The password to connect to the ProxySQL admin interface.
# @param stats_username
#   The username to connect with read-only permissions to the ProxySQL admin interface.
# @param stats_password
#   The password to connect with read-only permissions to the ProxySQL admin interface.
# @param admin_listen_ip
#   The ip where the ProxySQL admin interface will listen on.
# @param admin_listen_port
#   The port where the ProxySQL admin interface  will listen on.
# @param admin_listen_socket
#   The socket where the ProxySQL admin interface  will listen on. Changing this on a running system will result in failing runs.
# @param monitor_username
#   The username ProxySQL will use to connect to the configured mysql_servers.
# @param monitor_password
#   The password ProxySQL will use to connect to the configured mysql_servers.
# @param config_file
#   The file where the ProxySQL configuration is saved. This will only be configured if `manage_config_file` is set to `true`.
# @param manage_config_file
#   Determines whether this module will configure the ProxySQL configuration file.
# @param mycnf_file_name
#   Path of the my.cnf file where the connections details for the admin interface is save. This is required for the providers to work.
#   This will only be configured if `manage_mycnf_file` is set to `true`.
# @param manage_mycnf_file
#   Determines whether this module will configure the my.cnf file to connect to the admin interface.
#   This is required for the providers to work.
# @param restart
#   Determines whether this module will restart ProxySQL after reconfiguring the config file.
# @param load_to_runtime
#   Specifies whether te managed ProxySQL resources should be immediately loaded to the active runtime.
# @param save_to_disk
#   Specifies whether te managed ProxySQL resources should be immediately save to disk.
# @param manage_repo
#   Determines whether this module will manage the repositories where ProxySQL might be.
# @param version
#   The version of proxysql being managed. This parameter affects the repository configured when `manage_repo == true` and how the service is managed.
#   It does not affect the package version being installed. It is used as a hint to the puppet module on how to configure proxysql. To control the exact version
#   deployed, use `package_name` or `package_source`. Currently defaults to '2.7.1' or the value of the `proxysql_version` fact.
# @param package_source
#   location of a proxysql package.  When specified, this package will be installed with the `package\_provider` and the `manage_repo` setting will be ignored.
#   Since version 4 of this module, this defaults to `undef` and needs to be specified when you don't want to use a package from a repository.
# @param package_provider
#   provider for `package_source`.
# @param package_checksum_value
#   The checksum of the package. Optional and only applicable when `package_source` is provided.
# @param package_checksum_type
#   The 'type' of `package_checksum_value`. Optional and only applicable when `package_checksum_value` is provided.
# @param package_dependencies
#   A list of packages which should be additionally installed.
# @param sys_owner
#   Owner of the datadir and config_file.
# @param sys_group
#   Group of the datadir and config_file.
# @param override_config_settings
#   Which configuration variables should be overriden.
# @param node_name
#   The name of the node.
# @param cluster_name
#   If set, proxysql_servers with the same cluster_name will be automatically added to the same cluster and will
#   synchronize their configuration parameters.
# @param cluster_username
#   The username ProxySQL will use to connect to the configured mysql_clusters
# @param cluster_password
#   The password ProxySQL will use to connect to the configured mysql_clusters.
# @param mysql_client_package_name
#   The name of the mysql client package in your package manager.
# @param manage_hostgroup_for_servers
#   Determines whether this module will manage hostgroup_id for mysql_servers.
#   If false - it will skip difference in this value between manifest and defined in ProxySQL.
# @param mysql_servers
#   Array of mysql_servers, that will be created in ProxySQL.
# @param mysql_users
#   Array of mysql_users, that will be created in ProxySQL.
# @param mysql_hostgroups
#   Array of mysql_hostgroups, that will be created in ProxySQL.
# @param mysql_group_replication_hostgroups
#   Hash of mysql_group_replication_hostgroups, that will be created in ProxySQL.
# @param mysql_galera_hostgroups
#   Hash of mysql_galera_hostgroups, that will be created in ProxySQL.
# @param mysql_rules
#   Array of mysql_rules, that will be created in ProxySQL.
# @param schedulers
#   Array of schedulers, that will be created in ProxySQL.
# @param split_config
#   If set, ProxySQL config file will be split in 2: main config file with admin and mysql variables
#   and proxy config file with servers\users\hostgroups\scheduler params.
# @param proxy_config_file
#   The file where servers\users\hostgroups\scheduler\rules params of ProxySQL configuration are saved
#   This will only be configured if `split_config` is set to `true`.
# @param manage_proxy_config_file
#   Determines whether this module will update the ProxySQL proxy configuration file.
class proxysql (
  Optional[String[1]] $cluster_name = undef,
  String $package_name = 'proxysql',
  Optional[String] $mysql_client_package_name = undef,
  String $package_ensure = 'installed',
  Array[String] $package_install_options = [],
  String $service_name = 'proxysql',
  String $service_ensure = 'running',

  String $datadir = $proxysql::params::datadir,
  Stdlib::Filemode $datadir_mode = '0600',
  Boolean $manage_selinux = true,
  Boolean $manage_mysql_client = true,

  Optional[Stdlib::Unixpath] $errorlog_file = undef,
  Stdlib::Filemode $errorlog_file_mode = '0600',
  String $errorlog_file_owner = 'proxysql',
  String $errorlog_file_group = 'proxysql',

  String $listen_ip = '0.0.0.0',
  Integer $listen_port = 6033,
  String $listen_socket = $proxysql::params::listen_socket,

  String $admin_username = 'admin',
  Sensitive[String] $admin_password = Sensitive('admin'),
  String $admin_listen_ip = '127.0.0.1',
  Integer $admin_listen_port = 6032,
  String $admin_listen_socket = $proxysql::params::admin_listen_socket,

  String $stats_username = 'stats',
  Sensitive[String] $stats_password = Sensitive('stats'),

  String $monitor_username = 'monitor',
  Sensitive[String] $monitor_password = Sensitive('monitor'),

  Boolean $split_config = false,

  String $proxy_config_file = '/etc/proxysql_proxy.cnf',
  Boolean $manage_proxy_config_file = true,

  String $config_file = '/etc/proxysql.cnf',
  Boolean $manage_config_file = true,

  String $mycnf_file_name = '/root/.my.cnf',
  Boolean $manage_mycnf_file = true,

  Boolean $restart = false,

  Boolean $load_to_runtime = true,
  Boolean $save_to_disk = true,

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

  String $cluster_username = 'cluster',
  Sensitive[String] $cluster_password = Sensitive('cluster'),

  Hash $override_config_settings = {},

  String $node_name = "${facts['networking']['fqdn']}:${admin_listen_port}",
  Boolean $manage_hostgroup_for_servers = true,
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
    errorlog => $errorlog_file,
    admin_variables => {
      admin_credentials => "${admin_username}:${admin_password.unwrap}",
      mysql_ifaces      => "${admin_listen_ip}:${admin_listen_port};${admin_listen_socket}",
      stats_credentials => "${stats_username}:${stats_password.unwrap}",
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
  }.filter |$key, $val| { $val =~ NotUndef }

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
