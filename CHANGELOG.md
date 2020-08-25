# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v5.0.3](https://github.com/voxpupuli/puppet-proxysql/tree/v5.0.3) (2020-08-24)

[Full Changelog](https://github.com/voxpupuli/puppet-proxysql/compare/v5.0.2...v5.0.3)

**Merged pull requests:**

- modulesync 3.0.0 & puppet-lint updates [\#150](https://github.com/voxpupuli/puppet-proxysql/pull/150) ([ghoneycutt](https://github.com/ghoneycutt))
- Introduce `manage_mysql_client` boolean to toggle whether or not to include mysql::client [\#149](https://github.com/voxpupuli/puppet-proxysql/pull/149) ([walkleyn](https://github.com/walkleyn))
- Add support for changing stat user's credentials [\#145](https://github.com/voxpupuli/puppet-proxysql/pull/145) ([Goorzhel](https://github.com/Goorzhel))

## [v5.0.2](https://github.com/voxpupuli/puppet-proxysql/tree/v5.0.2) (2020-05-23)

[Full Changelog](https://github.com/voxpupuli/puppet-proxysql/compare/v5.0.1...v5.0.2)

**Fixed bugs:**

- Fixup Amazon 2016 issues [\#148](https://github.com/voxpupuli/puppet-proxysql/pull/148) ([alexjfisher](https://github.com/alexjfisher))
- provider: explicitly stringify output of mysql query [\#142](https://github.com/voxpupuli/puppet-proxysql/pull/142) ([SimonPe](https://github.com/SimonPe))
- Stop creating spurious files [\#141](https://github.com/voxpupuli/puppet-proxysql/pull/141) ([saz](https://github.com/saz))

**Merged pull requests:**

- Use voxpupuli-acceptance [\#144](https://github.com/voxpupuli/puppet-proxysql/pull/144) ([ekohl](https://github.com/ekohl))

## [v5.0.1](https://github.com/voxpupuli/puppet-proxysql/tree/v5.0.1) (2020-03-05)

[Full Changelog](https://github.com/voxpupuli/puppet-proxysql/compare/v5.0.0...v5.0.1)

**Fixed bugs:**

- ProxySQL 2 gets restarted as root [\#134](https://github.com/voxpupuli/puppet-proxysql/issues/134)
- Use distinct names for yum repos [\#138](https://github.com/voxpupuli/puppet-proxysql/pull/138) ([alexjfisher](https://github.com/alexjfisher))

**Closed issues:**

- Acceptance tests on CentOS 6 stopped working [\#137](https://github.com/voxpupuli/puppet-proxysql/issues/137)
- ProxySQL errors after 2.0.9 release [\#133](https://github.com/voxpupuli/puppet-proxysql/issues/133)

**Merged pull requests:**

- Avoid reloading proxysql 2 as root [\#135](https://github.com/voxpupuli/puppet-proxysql/pull/135) ([alexjfisher](https://github.com/alexjfisher))

## [v5.0.0](https://github.com/voxpupuli/puppet-proxysql/tree/v5.0.0) (2019-12-18)

[Full Changelog](https://github.com/voxpupuli/puppet-proxysql/compare/v4.0.0...v5.0.0)

**Breaking changes:**

- drop Ubuntu 14.04 support [\#123](https://github.com/voxpupuli/puppet-proxysql/pull/123) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Manage SELinux rules to allow logrotate to work [\#126](https://github.com/voxpupuli/puppet-proxysql/pull/126) ([alexjfisher](https://github.com/alexjfisher))

**Merged pull requests:**

- Run acceptance tests on CentOS 7.6 [\#129](https://github.com/voxpupuli/puppet-proxysql/pull/129) ([alexjfisher](https://github.com/alexjfisher))
- Remove default `config_settings` from params.pp [\#128](https://github.com/voxpupuli/puppet-proxysql/pull/128) ([alexjfisher](https://github.com/alexjfisher))
- Remove duplicate CONTRIBUTING.md file [\#124](https://github.com/voxpupuli/puppet-proxysql/pull/124) ([dhoppe](https://github.com/dhoppe))
- Replace `anchor` pattern with `contain` [\#122](https://github.com/voxpupuli/puppet-proxysql/pull/122) ([alexjfisher](https://github.com/alexjfisher))

## [v4.0.0](https://github.com/voxpupuli/puppet-proxysql/tree/v4.0.0) (2019-11-06)

[Full Changelog](https://github.com/voxpupuli/puppet-proxysql/compare/v3.1.0...v4.0.0)

**Breaking changes:**

- Replace `repo_version` with `version`, default to installing ProxySQL 2 and fix `restart => true` [\#116](https://github.com/voxpupuli/puppet-proxysql/pull/116) ([alexjfisher](https://github.com/alexjfisher))
- Don't install from github when `manage_repo` is false and remove unused `repo` parameter [\#112](https://github.com/voxpupuli/puppet-proxysql/pull/112) ([alexjfisher](https://github.com/alexjfisher))

**Implemented enhancements:**

- Add debian 10 support [\#119](https://github.com/voxpupuli/puppet-proxysql/pull/119) ([alexjfisher](https://github.com/alexjfisher))
- Add `proxysql_runtime` fact [\#117](https://github.com/voxpupuli/puppet-proxysql/pull/117) ([alexjfisher](https://github.com/alexjfisher))

**Fixed bugs:**

- Service management broken with ProxySQL 2 when `restart => true` [\#115](https://github.com/voxpupuli/puppet-proxysql/issues/115)
- Bugfix: Make classes dependent on the mysql package [\#113](https://github.com/voxpupuli/puppet-proxysql/pull/113) ([theosotr](https://github.com/theosotr))

**Closed issues:**

- Debian 10 Buster support [\#114](https://github.com/voxpupuli/puppet-proxysql/issues/114)

**Merged pull requests:**

- Clean up acceptance spec helper [\#118](https://github.com/voxpupuli/puppet-proxysql/pull/118) ([ekohl](https://github.com/ekohl))

## [v3.1.0](https://github.com/voxpupuli/puppet-proxysql/tree/v3.1.0) (2019-07-17)

[Full Changelog](https://github.com/voxpupuli/puppet-proxysql/compare/v3.0.0...v3.1.0)

**Implemented enhancements:**

- Add `datadir_mode` parameter [\#109](https://github.com/voxpupuli/puppet-proxysql/pull/109) ([alexjfisher](https://github.com/alexjfisher))

## [v3.0.0](https://github.com/voxpupuli/puppet-proxysql/tree/v3.0.0) (2019-07-09)

[Full Changelog](https://github.com/voxpupuli/puppet-proxysql/compare/v2.0.0...v3.0.0)

**Breaking changes:**

- modulesync 2.5.1 & drop Puppet 4 [\#86](https://github.com/voxpupuli/puppet-proxysql/pull/86) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add proxy\_mysql\_galera\_hostgroup type [\#103](https://github.com/voxpupuli/puppet-proxysql/pull/103) ([alexjfisher](https://github.com/alexjfisher))
- Added the ability to forcibly set NULL for fields in settings proxy\_mysql\_query\_rule [\#98](https://github.com/voxpupuli/puppet-proxysql/pull/98) ([identw](https://github.com/identw))
- add repo for 2.0.x [\#94](https://github.com/voxpupuli/puppet-proxysql/pull/94) ([kubicgruenfeld](https://github.com/kubicgruenfeld))
- Support for Group Replication Hostgroups [\#68](https://github.com/voxpupuli/puppet-proxysql/pull/68) ([CyberLine](https://github.com/CyberLine))

**Fixed bugs:**

- Fix `Proxysql::GroupReplicationHostgroup` type [\#105](https://github.com/voxpupuli/puppet-proxysql/pull/105) ([alexjfisher](https://github.com/alexjfisher))
- Fix and refactor install.pp relationships [\#93](https://github.com/voxpupuli/puppet-proxysql/pull/93) ([alexjfisher](https://github.com/alexjfisher))
- Bugfix: Add missing dependencies [\#91](https://github.com/voxpupuli/puppet-proxysql/pull/91) ([theosotr](https://github.com/theosotr))
- fix bug in types that int\[0,1\] were boolean [\#81](https://github.com/voxpupuli/puppet-proxysql/pull/81) ([MaxFedotov](https://github.com/MaxFedotov))

**Closed issues:**

- Ubuntu 18.04 Bionic Beaver support [\#75](https://github.com/voxpupuli/puppet-proxysql/issues/75)
- Installation failure on deb 9.5 [\#69](https://github.com/voxpupuli/puppet-proxysql/issues/69)
- readd stdlib dependency; bump mysql/apt dependency [\#65](https://github.com/voxpupuli/puppet-proxysql/issues/65)

**Merged pull requests:**

- Allow puppetlabs/stdlib 6 and puppetlabs/mysql 10 [\#107](https://github.com/voxpupuli/puppet-proxysql/pull/107) ([alexjfisher](https://github.com/alexjfisher))
- Fix RedHat yum repo baseurls [\#106](https://github.com/voxpupuli/puppet-proxysql/pull/106) ([alexjfisher](https://github.com/alexjfisher))
- readd stdlib module; allow puppetlabs/mysql 8.x [\#104](https://github.com/voxpupuli/puppet-proxysql/pull/104) ([bastelfreak](https://github.com/bastelfreak))
- Support Ubuntu 18.04 with proxysql 2.0 [\#102](https://github.com/voxpupuli/puppet-proxysql/pull/102) ([alexjfisher](https://github.com/alexjfisher))
- Allow puppetlabs/apt 7.x [\#100](https://github.com/voxpupuli/puppet-proxysql/pull/100) ([dhoppe](https://github.com/dhoppe))
- Fix `Proxysql::User` data type to match what's expected by `proxy_mysql_user` resource type [\#88](https://github.com/voxpupuli/puppet-proxysql/pull/88) ([CyberLine](https://github.com/CyberLine))
- Allow puppetlabs-mysql 7.x [\#87](https://github.com/voxpupuli/puppet-proxysql/pull/87) ([ekohl](https://github.com/ekohl))
- modulesync 2.2.0 and allow puppet 6.x [\#79](https://github.com/voxpupuli/puppet-proxysql/pull/79) ([bastelfreak](https://github.com/bastelfreak))
- Minor doc update [\#73](https://github.com/voxpupuli/puppet-proxysql/pull/73) ([mcrauwel](https://github.com/mcrauwel))
- Update Readme me and add a link to our CoC [\#72](https://github.com/voxpupuli/puppet-proxysql/pull/72) ([mcrauwel](https://github.com/mcrauwel))
- implemented more extensive acceptance tests than just "include proxysql" [\#71](https://github.com/voxpupuli/puppet-proxysql/pull/71) ([mcrauwel](https://github.com/mcrauwel))
- allow puppetlabs/apt 6.x [\#70](https://github.com/voxpupuli/puppet-proxysql/pull/70) ([bastelfreak](https://github.com/bastelfreak))

## [v2.0.0](https://github.com/voxpupuli/puppet-proxysql/tree/v2.0.0) (2018-09-10)

[Full Changelog](https://github.com/voxpupuli/puppet-proxysql/compare/v1.1.2...v2.0.0)

**Breaking changes:**

- package manager updates [\#47](https://github.com/voxpupuli/puppet-proxysql/pull/47) ([mcrauwel](https://github.com/mcrauwel))
- Change transaction persistent default [\#35](https://github.com/voxpupuli/puppet-proxysql/pull/35) ([mcrauwel](https://github.com/mcrauwel))

**Implemented enhancements:**

- Enable acceptance tests on travis; add debian 9 support [\#64](https://github.com/voxpupuli/puppet-proxysql/pull/64) ([bastelfreak](https://github.com/bastelfreak))
- Allow puppetlabs/stdlib 5.x, puppetlabs/apt 6.x and puppetlabs/mysql 6.x [\#63](https://github.com/voxpupuli/puppet-proxysql/pull/63) ([bastelfreak](https://github.com/bastelfreak))
- Support to add resource via class parameters. Add manage\_hostgroup\_fo… [\#62](https://github.com/voxpupuli/puppet-proxysql/pull/62) ([MaxFedotov](https://github.com/MaxFedotov))
- add ability to split config into 2 files [\#60](https://github.com/voxpupuli/puppet-proxysql/pull/60) ([MaxFedotov](https://github.com/MaxFedotov))
- Declare passwords as Sensitive [\#51](https://github.com/voxpupuli/puppet-proxysql/pull/51) ([jfroche](https://github.com/jfroche))
- Adding Repo Management for Centos, Redhat, LinuzAmazon [\#16](https://github.com/voxpupuli/puppet-proxysql/pull/16) ([alexvaque](https://github.com/alexvaque))

**Fixed bugs:**

- Proxysql on Debian should now run under the proxysql user account [\#43](https://github.com/voxpupuli/puppet-proxysql/issues/43)
- Default weight 0 causes issue [\#28](https://github.com/voxpupuli/puppet-proxysql/issues/28)
- Module push 'OFFLINE\_SOFT' back online [\#25](https://github.com/voxpupuli/puppet-proxysql/issues/25)
- changing the admin-admin\_credentials results in failing puppet runs [\#22](https://github.com/voxpupuli/puppet-proxysql/issues/22)
- Unwrap passwords before writing to file [\#53](https://github.com/voxpupuli/puppet-proxysql/pull/53) ([jjspark](https://github.com/jjspark))
- Override all settings [\#52](https://github.com/voxpupuli/puppet-proxysql/pull/52) ([jjspark](https://github.com/jjspark))
- Fixed managing admin credentials [\#34](https://github.com/voxpupuli/puppet-proxysql/pull/34) ([mcrauwel](https://github.com/mcrauwel))
- proxy\_mysql\_server needs a default for status in order for the insert to succeed [\#33](https://github.com/voxpupuli/puppet-proxysql/pull/33) ([mcrauwel](https://github.com/mcrauwel))

**Closed issues:**

- puppet 5 compatibility \(bump dependencies for puppetlabs-apt to something more modern\) [\#66](https://github.com/voxpupuli/puppet-proxysql/issues/66)
- New versions of proxysql [\#38](https://github.com/voxpupuli/puppet-proxysql/issues/38)
- Please, could you add a release/tag for new RPM features?  [\#29](https://github.com/voxpupuli/puppet-proxysql/issues/29)
- Mysql query rule changed [\#24](https://github.com/voxpupuli/puppet-proxysql/issues/24)
- Ubuntu support [\#20](https://github.com/voxpupuli/puppet-proxysql/issues/20)

**Merged pull requests:**

- add support for Proxysql cluster [\#58](https://github.com/voxpupuli/puppet-proxysql/pull/58) ([MaxFedotov](https://github.com/MaxFedotov))
- Remove docker nodesets [\#50](https://github.com/voxpupuli/puppet-proxysql/pull/50) ([bastelfreak](https://github.com/bastelfreak))
- drop EOL OSs; fix puppet version range [\#48](https://github.com/voxpupuli/puppet-proxysql/pull/48) ([bastelfreak](https://github.com/bastelfreak))
- bump puppet to latest supported version 4.10.0 [\#46](https://github.com/voxpupuli/puppet-proxysql/pull/46) ([bastelfreak](https://github.com/bastelfreak))
- bump puppet version dependency to \>= 4.7.1 \< 6.0.0 [\#40](https://github.com/voxpupuli/puppet-proxysql/pull/40) ([bastelfreak](https://github.com/bastelfreak))
- fixed doc error [\#36](https://github.com/voxpupuli/puppet-proxysql/pull/36) ([mcrauwel](https://github.com/mcrauwel))
- fixed parsing of prefetched data \(fix \#24\) [\#30](https://github.com/voxpupuli/puppet-proxysql/pull/30) ([mcrauwel](https://github.com/mcrauwel))
- config file: owner and group configurable \(fix\) [\#27](https://github.com/voxpupuli/puppet-proxysql/pull/27) ([FrankVanDamme](https://github.com/FrankVanDamme))
- Fixes for ubuntu support [\#23](https://github.com/voxpupuli/puppet-proxysql/pull/23) ([mcrauwel](https://github.com/mcrauwel))
- Fix contributors typo [\#21](https://github.com/voxpupuli/puppet-proxysql/pull/21) ([rgomezcasas](https://github.com/rgomezcasas))
- Deleting non UTF8-char [\#18](https://github.com/voxpupuli/puppet-proxysql/pull/18) ([narcisbcn](https://github.com/narcisbcn))
- Add option to define install options [\#15](https://github.com/voxpupuli/puppet-proxysql/pull/15) ([jfroche](https://github.com/jfroche))

## [v1.1.2](https://github.com/voxpupuli/puppet-proxysql/tree/v1.1.2) (2017-02-12)

[Full Changelog](https://github.com/voxpupuli/puppet-proxysql/compare/v1.1.1...v1.1.2)

**Implemented enhancements:**

- make ensure for package and service configurable [\#11](https://github.com/voxpupuli/puppet-proxysql/pull/11) ([mcrauwel](https://github.com/mcrauwel))

**Merged pull requests:**

- modulesync 0.20.0 [\#12](https://github.com/voxpupuli/puppet-proxysql/pull/12) ([mcrauwel](https://github.com/mcrauwel))

## [v1.1.1](https://github.com/voxpupuli/puppet-proxysql/tree/v1.1.1) (2017-02-12)

[Full Changelog](https://github.com/voxpupuli/puppet-proxysql/compare/v1.1.0...v1.1.1)

## [v1.1.0](https://github.com/voxpupuli/puppet-proxysql/tree/v1.1.0) (2017-02-11)

[Full Changelog](https://github.com/voxpupuli/puppet-proxysql/compare/1.0.0...v1.1.0)

**Fixed bugs:**

- Unable to publish to forge because of vendor/ [\#10](https://github.com/voxpupuli/puppet-proxysql/issues/10)

**Merged pull requests:**

- Gitignore ruby version [\#9](https://github.com/voxpupuli/puppet-proxysql/pull/9) ([mcrauwel](https://github.com/mcrauwel))
- \[release testing\] [\#8](https://github.com/voxpupuli/puppet-proxysql/pull/8) ([bastelfreak](https://github.com/bastelfreak))
- proper Markdown formatting for release regex to pass [\#7](https://github.com/voxpupuli/puppet-proxysql/pull/7) ([mcrauwel](https://github.com/mcrauwel))
- create 1.1.0 release [\#6](https://github.com/voxpupuli/puppet-proxysql/pull/6) ([mcrauwel](https://github.com/mcrauwel))
- update metadata to point to voxpupuli repo [\#5](https://github.com/voxpupuli/puppet-proxysql/pull/5) ([mcrauwel](https://github.com/mcrauwel))
- updated docs [\#3](https://github.com/voxpupuli/puppet-proxysql/pull/3) ([mcrauwel](https://github.com/mcrauwel))
- manage repo's [\#2](https://github.com/voxpupuli/puppet-proxysql/pull/2) ([mcrauwel](https://github.com/mcrauwel))

## [1.0.0](https://github.com/voxpupuli/puppet-proxysql/tree/1.0.0) (2017-02-07)

[Full Changelog](https://github.com/voxpupuli/puppet-proxysql/compare/2b002103f11c460a659eb0928d5989bd1836b9ee...1.0.0)

**Merged pull requests:**

- Rspec testen implemented [\#1](https://github.com/voxpupuli/puppet-proxysql/pull/1) ([rgevaert](https://github.com/rgevaert))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
