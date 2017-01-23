#### Table of Contents

1. [Overview](#overview)
2. [Setup - The basics of getting started with proxysql](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with proxysql](#beginning-with-proxysql)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The proxysql module installs, configures and manages the [ProxySQL](https://github.com/sysown/proxysql) service.

This module will install the ProxySQL and manage it's configuration. It also extends Puppet to be able to manage `mysql_users`, `mysql_servers`, `mysql_replication_hostgroups`, `mysql_query_rules`, `scheduler` and `global_variables`.


## Setup

### Setup Requirements **OPTIONAL**

The module requires Puppet 4.x and currently supports only Debian 8 "Jessie" (and possibly Debian 7 "Wheezy").

*Note:* the ProxySQL-package is currently not in any public upstream package manager. So you should consider uploading it to a private package manager and manage that before calling the proxysql-class.

### Beginning with proxysql

To install the ProxySQL software with all the default options:
```
include ::proxysql
```

You can customize options such as (but not limited to) `listen_port`, `admin_password`, `monitor_password`, ...
```
  class { '::proxysql':
    listen_port              => 3306,
    admin_password           => '654321',
    monitor_password         => '123456',
    override_config_settings => $override_settings
  }
```

## Usage

Configuration is done by the `proxysql` class.

### Customize config settings

You can override any configuration setting by using the `override_config_settings` hash. This hash resembles the structure of the `proxysql.cnf` file

```
{
    admin_variables => {
      refresh_interval => 2000,
      ...
    },
    mysql_variables => {
      monitor_writer_is_also_reader => false,
      ...
    },
    mysql_servers => {
      'mysql1' => {
         'address' => '127.0.0.1',
         'port'    => 33061,
       },
      'mysql2' => {
         'address' => '127.0.0.1',
         'port'    => 33062,
       },
      ...
    },
    mysql_users => { ... },
    mysql_query_rules => { ... },
    scheduler => { ... },
    mysql_replication_hostgroups => { ... },

}
```

## Reference

### Public classes
* [`proxysql`](#proxysql): Installs and configures ProxySQL

### Private classes
* `proxysql::install`: Installs the package(s)
* `proxysql::config`: Manages the configuration files and `global_variables`
* `proxysql::service`: Manages the service

### parameters
#### `proxysql`
##### `package_name`
The name of the ProxySQL package in your package manager. Defaults to 'proxysql'

##### `service_name`
The name of the ProxySQL service resource. Defaults to 'proxysql'

##### `datadir`
The directory where ProxySQL will store it's data. defaults to '/var/lib/proxysql'

##### `listen_ip`
The ip where the ProxySQL service will listen on. Defaults to '0.0.0.0' aka all configured IP's on the machine

##### `listen_port`
The port where the ProxySQL service will listen on. Defaults to '6033'

##### `listen_socket`
The socket where the ProxySQL service will listen on. Defaults to '/tmp/proxysql.sock'

##### `admin_username`
The username to connect to the ProxySQL admin interface. Defaults to 'admin'

##### `admin_password`
The password to connect to the ProxySQL admin interface. Defaults to 'admin'

##### `admin_listen_ip`
The ip where the ProxySQL admin interface will listen on. Defaults to '127.0.0.1'

##### `admin_listen_port`
The port where the ProxySQL admin interface  will listen on. Defaults to '6032'

##### `admin_listen_socket`
The socket where the ProxySQL admin interface  will listen on. Defaults to '/tmp/proxysql_admin.sock'

##### `monitor_username`
The username ProxySQL will use to connect to the configured mysql_servers. Defaults to 'monitor'

##### `monitor_password`
The password ProxySQL will use to connect to the configured mysql_servers. Defaults to 'monitor'

##### `config_file`
The file where the ProxySQL configuration is saved. This will only be configured if `manage_config_file` is set to `true`.
Defaults to '/etc/proxysql.cnf'

##### `manage_config_file`
Determines wheter this module will configure the ProxySQL configuration file. Defaults to 'true'

##### `mycnf_file_name`
Path of the my.cnf file where the connections details for the admin interface is save. This is required for the providers to work.
This will only be configured if `manage_mycnf_file` is set to `true`. Defaults to '/root/.my.cnf'

##### `manage_mycnf_file`
Determines wheter this module will configure the my.cnf file to connect to the admin interface. Defaults to 'true'

##### `restart`
Determines wheter this module will restart ProxySQL after reconfiguring the config file. Defaults to 'false'

##### `load_to_runtime`
Specifies wheter te managed ProxySQL resources should be immediately loaded to the active runtime. Boolean, defaults to 'true'.

##### `save_to_disk`
Specifies wheter te managed ProxySQL resources should be immediately save to disk. Boolean, defaults to 'true'.

##### `override_config_settings`
Which configuration variables should be overriden. Hash, defaults to {} (empty hash).


## Types
#### proxy_global_variable
`proxy_global_variable` manages a variable in the ProxySQL `global_variables` admin table.

##### `name`
The name of the variable.

##### `load_to_runtime`
Specifies wheter the resource should be immediately loaded to the active runtime. Boolean, defaults to 'true'.

##### `save_to_disk`
Specifies wheter the resource should be immediately save to disk. Boolean, defaults to 'true'.

##### `value`
The value of the variable.

#### proxy_mysql_replication_hostgroup
`proxy_mysql_replication_hostgroup` manages an entry in the ProxySQL `mysql_replication_hostgroups` admin table.

##### `ensure`
Whether the resource is present. Valid values are 'present', 'absent'. Defaults to 'present'.

##### `name`
Name to describe the hostgroup config. Must be in a '`writer_hostgroup`-`reader_hostgroup`' format.

##### `load_to_runtime`
Specifies wheter the resource should be immediately loaded to the active runtime. Boolean, defaults to 'true'.

##### `save_to_disk`
Specifies wheter the resource should be immediately save to disk. Boolean, defaults to 'true'.

##### `writer_hostgroup`
Id of the writer hostgroup. Required.

##### `reader_hostgroup`
Id of the reader hostgroup. Required.

##### `comment`
Optional comment.

#### proxy_mysql_server
`proxy_mysql_server` manages an entry in the ProxySQL `mysql_servers` admin table.

##### `ensure`
Whether the resource is present. Valid values are 'present', 'absent'. Defaults to 'present'.

##### `name`
Name to describe the hostgroup config. Must be in a '`hostname`:`port`-`hostgroup_id`' format.

##### `load_to_runtime`
Specifies wheter the resource should be immediately loaded to the active runtime. Boolean, defaults to 'true'.

##### `save_to_disk`
Specifies wheter the resource should be immediately save to disk. Boolean, defaults to 'true'.

##### `hostgroup_id`
Id of the hostgroup this server wil be configured to be part of. Integer value, required.

##### `hostname`
Hostname of the server. Required.

##### `port`
Port of the server. Required. Defaults to 3306.

##### `status`
Status of the server. Should be one of the following values: 'ONLINE', 'OFFLINE_SOFT', 'OFFLINE_HARD', 'SHUNNED'. Defaults to 'ONLINE'.

##### `weight`
Weight value of the server. The higher the value, the higher the probability this server will be chosen from the hostgroup. Integer, defaults to 0.

##### `compression`
Compression value of the serer. If the value is greater than 0, new connections to that server will use compression. Integer, defaults to 0.

##### `max_connections`
The maximum number of connections ProxySQL will open to this backend server. Even though this server will have the highest weight, no new connections will be opened to it once this limit is hit. Please ensure that the backend is configured with a correct value of max_connections to avoid that ProxySQL will try to go beyond that limit. Integer, defaults to 1000.

##### `max_replication_lag`
If greater and 0, ProxySQL will reguarly monitor replication lag and if it goes beyond such threshold it will temporary shun the host until replication catch ups. Integer, defaults to 0.

##### `use_ssl`
If set to 1, connections to the backend will use SSL. Values 0 or 1. Defaults to 0.

##### `max_latency_ms`
Ping time is regularly monitored. If a host has a ping time greater than max_latency_ms it is excluded from the connection pool (although the server stays ONLINE. Integer, defaults to 0.

##### `comment`
Optional comment.


#### proxy_mysql_user
`proxy_mysql_user` manages an entry in the ProxySQL `mysql_users` admin table.

##### `ensure`
Whether the resource is present. Valid values are 'present', 'absent'. Defaults to 'present'.

##### `name`
Username for the user. Required.

##### `load_to_runtime`
Specifies wheter the resource should be immediately loaded to the active runtime. Boolean, defaults to 'true'.

##### `save_to_disk`
Specifies wheter the resource should be immediately save to disk. Boolean, defaults to 'true'.

##### `password`
Password for the user. Required.
*Note*: you should make sure that the global variable `admin-hashed_passwords` is set to `true` and then encrypt this password using the `mysql_password()` function.

##### `active`
Flag to determine if this user is active or not. Values 0 or 1. Defaults to 1.

##### `use_ssl`
Flag to determine if this user uses SSL or not. Values 0 or 1. Defaults to 0.

##### `default_hostgroup`
Default hostgroup for the user. Integer, defaults to 0.

##### `default_schema`
Default schema for the user. String, defaults to ''.

##### `schema_locked`
Is the user locked in the `default_schema` or not. Values 0 or 1. Defaults to 0.

##### `transaction_persistent`
Disable routing across hostgroups once a transaction has started for a specific user. Values 0 or 1. Defaults to 0.

##### `fast_forward`
Flag to determine fast forward or not. Values 0 or 1. Defaults to 0.

##### `backend`
Is this a backend user. Values 0 or 1. Defaults to 1.

##### `frontend`
Is this a frontend user. Values 0 or 1. Defaults to 1.

## Limitations

The module requires Puppet 4.x and currently supports only Debian 8 "Jessie" (and possibly Debian 7 "Wheezy").
It depends on the [puppetlabs](https://puppet.com/)/[mysql](https://github.com/puppetlabs/puppetlabs-mysql) module (>= 3.x)

## Development

This module is originally developed by [Matthias Crauwels](mailto:matthias@crauwels.net) for use at [Ghent University, Belgium](http://www.ugent.be). This module is published under the Apache 2.0 license.

We are open to feature requests, bug reports, contributions, etc...

## Contributors

Original author: Matthias Crauwels
