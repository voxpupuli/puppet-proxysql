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

The proxysql module installs, configures and manages the [ProxySQL|https://github.com/sysown/proxysql] service.

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

If your most recent release breaks compatibility or requires particular steps for upgrading, you may wish to include an additional section here: Upgrading (For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

## Usage

Put the classes, types, and resources for customizing, configuring, and doing the fancy stuff with your module here. 

## Reference

Here, list the classes, types, providers, facts, etc contained in your module. This section should include all of the under-the-hood workings of your module so people know what the module is touching on their system but don't need to mess with things. (We are working on automating this section!)

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

Since your module is awesome, other users will want to play with it. Let them know what the ground rules for contributing are.

## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You may also add any additional sections you feel are necessary or important to include here. Please use the `## ` header. 
