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

This module will install the ProxySQL and manage it's configuration. It also extends Puppet to be able to manage `mysql_users`, `mysql_servers`, `mysql_replication_hostgroups`, `mysql_query_rules` and `global_variables`.


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
* `proxysql`: Installs and configures ProxySQL

### Private classes
* `proxysql::install`: Installs the packages
* `proxysql::config`: Installs the packages
* `proxysql::service`: Installs the packages

### Types
#### proxy_global_variable
`proxy_global_variable` manages a variable in the ProxySQL `global_variables` admin table.

##### `name`
The name of the variable. 

##### `value`
The value of the variable.

#### proxy_mysql_replication_hostgroup
`proxy_mysql_replication_hostgroup` manages an entry in the ProxySQL `mysql_replication_hostgroups` admin table.

##### `ensure`
Whether the resource is present. Valid values are 'present', 'absent'. Defaults to 'present'.

##### `name`
Name to describe the hostgroup config. Must be in a '`writer_hostgroup`-`reader_hostgroup`' format.

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

##### `hostgroup_id`
##### `hostname`
##### `port`
##### `status`
##### `weight`
##### `compression`
##### `max_connections`
##### `max_replication_lag`
##### `use_ssl`
##### `max_latency_ms`
##### `comment`


#### proxy_mysql_user
`proxy_mysql_user` manages an entry in the ProxySQL `mysql_users` admin table.

##### `ensure`
Whether the resource is present. Valid values are 'present', 'absent'. Defaults to 'present'.

##### `name`
Username for the user.

##### `password`
##### `active`
##### `use_ssl`
##### `default_hostgroup`
##### `default_schema`
##### `schema_locked`
##### `transaction_persistent`
##### `fast_forward`
##### `backend`
##### `frontend`

## Limitations

The module requires Puppet 4.x and currently supports only Debian 8 "Jessie" (and possibly Debian 7 "Wheezy").
It depends on the [puppetlabs](https://puppet.com/)/[mysql](https://github.com/puppetlabs/puppetlabs-mysql) module (>= 3.x)

## Development

This module is originally developed by [Matthias Crauwels](mailto:matthias@crauwels.net) for use at [Ghent University, Belgium](http://www.ugent.be). This module is published under the Apache 2.0 license.

We are open to feature requests, bug reports, contributions, etc...

## Contributors

Original author: Matthias Crauwels
