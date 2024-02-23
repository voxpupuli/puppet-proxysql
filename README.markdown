# Puppet module for ProxySQL

[![CI](https://github.com/voxpupuli/puppet-proxysql/actions/workflows/ci.yml/badge.svg)](https://github.com/voxpupuli/puppet-proxysql/actions/workflows/ci.yml)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-proxysql/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-proxysql)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/proxysql.svg)](https://forge.puppet.com/puppet/proxysql)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/proxysql.svg)](https://forge.puppet.com/puppet/proxysql)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/proxysql.svg)](https://forge.puppet.com/puppet/proxysql)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/proxysql.svg)](https://forge.puppet.com/puppet/proxysql)

## Table of Contents

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

This module will install the ProxySQL and manage it's configuration. It also extends Puppet to be able to manage `mysql_users`, `mysql_servers`, `mysql_replication_hostgroups`, `mysql_galera_hostgroups`, `mysql_query_rules`, `proxysql_servers`, `scheduler` and `global_variables`.

## Setup

### Setup Requirements

The module requires Puppet 5.5.8 and above. It also depends on:

* [puppetlabs/mysql](https://forge.puppet.com/puppetlabs/mysql)
* [puppetlabs/apt](https://forge.puppet.com/puppetlabs/apt) - (Not strictly required on non Debian based systems)
* [puppetlabs/stdlib](https://forge.puppet.com/puppetlabs/stdlib)
* [camptocamp/systemd](https://forge.puppet.com/camptocamp/systemd) - (Not strictly required if installing ProxySQL 1.4)

For up to date details on external dependencies, please see the [metadata.json](https://github.com/voxpupuli/puppet-proxysql/blob/master/metadata.json) or for released versions, the [puppet forge page](https://forge.puppet.com/puppet/proxysql/dependencies).

[puppet/selinux](https://forge.puppet.com/puppet/selinux) is an optional `soft` dependency and not even listed in the [metadata.json](https://github.com/voxpupuli/puppet-proxysql/blob/master/metadata.json). No Operating Systems *require* this module to be present, but if it is, it will be used to install SELinux rules that allow logrotate to work. See [manage\_selinux](REFERENCE.md#-proxysql--manage_selinux)

### Beginning with proxysql

To install the ProxySQL software with all the default options:

```puppet
include proxysql
```

By default, packages come from the official upstream package repositories which the module will configure.
On new installations, (by default), the 2.0.x repository will be configured. If ProxySQL is already installed, then the repository matching the currently installed version
will be used.

To force the use of 1.4.x packages, use the `version` parameter.  (Note, the example below does not force the installation of `1.4.16`, it only ensures the correct repository
is configured and that ProxySQL will be configured as if the version installed is `1.4.16`)

```puppet
class { 'proxysql':
  version => '1.4.16',
}
```

To use your Operating System's own packages set `manage_repo => false`.

```puppet
class { 'proxysql':
  manage_repo => false,
}
```

or you can configure your own repository by eg. declaring your own `yumrepo`, `pulp_rpmbind` or `rhn_channel` resource and setting `manage_repo => false`.

For example, using `pulp` and [katello/pulp](https://forge.puppet.com/katello/pulp)

```puppet
pulp_rpmbind { 'my_proxysql_repo':}

class { 'proxysql':
  manage_repo => false,
  require     => Pulp_rpmbind['my_proxysql_repo'],
}
```

Alternatively, you can specify a `package_source` and associated options.  This mimics the old, (pre version 4), behaviour of this module.

```puppet
class { 'proxysql':
  package_source         => 'https://github.com/sysown/proxysql/releases/download/v1.4.11/proxysql_1.4.11-debian9_amd64.deb',
  package_checksum_value => '65a3c2b98eefa42946ee59eef18ba18534c2a39d',
  package_checksum_type  => 'sha1',
}
```

You can customize options such as (but not limited to) `listen_port`, `admin_password`, `monitor_password`, ...

```puppet
  class { 'proxysql':
    listen_port              => 3306,
    admin_password           => Sensitive('654321'),
    monitor_password         => Sensitive('123456'),
    override_config_settings => $override_settings,
  }
```

You can configure users\hostgroups\rules\schedulers using class parameters

```puppet
  class { 'proxysql':
     mysql_servers    => [
       {
         'db1' => {
           'port' => 3306,
           'hostgroup_id' => 1,
         }
       },
       {
         'db2' => {
           'hostgroup_id' => 2,
         }
       },
     ],
     mysql_users      => [
       {
         'app' => {
           'password' => '*92C74DFBDA5D60ABD41EFD7EB0DAE389F4646ABB',
           'default_hostgroup' => 1,
         }
       },
       {
         'ro'  => {
           'password' => mysql_password('MyReadOnlyUserPassword'),
           'default_hostgroup' => 2,
         }
       },
     ],
     mysql_hostgroups => [
       {
         '1-2' => {
           'writer' => 1,
           'reader' => 2,
         }
       },
     ],
     mysql_group_replication_hostgroups => [
       {
         'hostgroup 2' => {
           'reader'  => 10,
           'writer'  => 5,
           'backup'  => 2,
           'offline' => 11,
         }
       },
     ],
     mysql_galera_hostgroups => [
       {
         'galera hostgroup 1' => {
           'writer'  => 1,
           'backup'  => 2,
           'reader'  => 3,
           'offline' => 4,
         }
       },
     ],
     mysql_rules      => [
       {
         'mysql_query_rule-1' => {
           'rule_id'         => 1,
           'match_pattern'   => 'testtable',
           'replace_pattern' => 'test.newtable',
           'apply'           => 1,
           'active'          => 1,
         }
       },
     ],
     schedulers       => [
       {
         'scheduler-1' => {
           'scheduler_id'  => 1,
           'active'        => 0,
           'filename'      => '/usr/bin/whoami',
         }
       },
     ],
```

Or by using individual resources:

```puppet
  class { 'proxysql':
    listen_port    => 3306,
    admin_password => Sensitive('SuperSecretPassword'),
  }

  proxy_mysql_server { '192.168.33.31:3306-31':
    hostname     => '192.168.33.31',
    port         => 3306,
    hostgroup_id => 31,
  }

  proxy_mysql_server { '192.168.33.32:3306-31':
    hostname     => '192.168.33.32',
    port         => 3306,
    hostgroup_id => 31,
  }

  proxy_mysql_server { '192.168.33.33:3306-31':
    hostname     => '192.168.33.33',
    port         => 3306,
    hostgroup_id => 31,
  }

  proxy_mysql_server { '192.168.33.34:3306-31':
    hostname     => '192.168.33.34',
    port         => 3306,
    hostgroup_id => 31,
  }

  proxy_mysql_server { '192.168.33.35:3306-31':
    hostname     => '192.168.33.35',
    port         => 3306,
    hostgroup_id => 31,
  }

  proxy_mysql_replication_hostgroup { '30-31':
    writer_hostgroup => 30,
    reader_hostgroup => 31,
    comment          => 'Replication Group 1',
  }

  proxy_mysql_replication_hostgroup { '20-21':
    writer_hostgroup => 20,
    reader_hostgroup => 21,
    comment          => 'Replication Group 2',
  }

  proxy_mysql_group_replication_hostgroup { '5-2-10-11':
    reader_hostgroup        => 10,
    writer_hostgroup        => 5,
    backup_writer_hostgroup => 2,
    offline_hostgroup       => 11,
  }

  proxy_mysql_galera_hostgroup { '1-2-3-4':
    writer_hostgroup        => 1,
    backup_writer_hostgroup => 2,
    reader_hostgroup        => 3,
    offline_hostgroup       => 4,
  }

  proxy_mysql_user { 'tester':
    password          => 'testerpwd',
    default_hostgroup => 30,
  }

  proxy_mysql_query_rule { 'mysql_query_rule-1':
    rule_id               => 1,
    match_pattern         => '^SELECT',
    apply                 => 1,
    active                => 1,
    destination_hostgroup => 31,
  }

  proxy_scheduler { 'scheduler-1':
    scheduler_id => 1,
    active       => 0,
    filename     => '/usr/bin/whoami',
  }

  proxy_scheduler { 'scheduler-2':
    scheduler_id => 2,
    active       => 0,
    interval_ms  => 1000,
    filename     => '/usr/bin/id',
  }
```

## Usage

Configuration is done by the `proxysql` class.

### Customize config settings

You can override any configuration setting by using the `override_config_settings` hash. This hash resembles the structure of the `proxysql.cnf` file

```puppet
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
      '127.0.0.1:33061-1' => {
         'address'      => '127.0.0.1',
         'port'         => 33061,
         'hostgroup_id' => 1,
       },
      '127.0.0.1:33062-1' => {
         'address'      => '127.0.0.1',
         'port'         => 33062,
         'hostgroup_id' => 1,
       },
      ...
    },
    mysql_users => { ... },
    mysql_query_rules => { ... },
    scheduler => { ... },
    mysql_replication_hostgroups => { ... },
    mysql_galera_hostgroups => { ... },

}
```

## Reference

see [REFERENCE.md](REFERENCE.md)

### `proxysql\_runtime` fact

This module ships a fact that you may find useful in your profiles.  It is not used by the module itself.
The `proxysql_runtime` fact queries ProxySQL and returns a hash containing the contents of several of the [runtime tables](https://github.com/sysown/proxysql/wiki/Main-(runtime)).

The fact will only return data if the [mysql2](https://rubygems.org/gems/mysql2) library is installed in your puppet agent's gem environment.

For systems using official puppet packages, (All In One packages), the following code can be used to install this gem and make the fact
available.

```puppet
$dev_packages = ['mariadb-devel','make','gcc']
ensure_packages($dev_packages)

package { 'mysql2 gem':
  ensure   => present,
  name     => 'mysql',
  provider => 'puppet_gem',
  require  => Package[$dev_packages],
}
```

## Limitations

The module requires Puppet 5.5 or above. The `proxysql_runtime` fact only works when using the default value for `mycnf_file_name`.

## Development

This module is originally developed by [Matthias Crauwels](mailto:matthias@crauwels.net) for use at [Ghent University, Belgium](http://www.ugent.be). This module is published under the Apache 2.0 license.
It is now maintained by [Vox Pupuli](https://voxpupuli.org)

We are open to feature requests, bug reports, contributions, etc...

## Contributors

Original author: Matthias Crauwels
