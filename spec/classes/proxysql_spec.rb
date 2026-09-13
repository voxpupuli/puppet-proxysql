# frozen_string_literal: true

require 'spec_helper'
require 'deep_merge'

describe 'proxysql' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'proxysql class without any parameters' do
          it { is_expected.to contain_class('proxysql') }
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('proxysql::params') }
          it { is_expected.to contain_class('proxysql::prerequisites').that_comes_before('Class[proxysql::repo]') }
          it { is_expected.to contain_class('proxysql::repo').that_comes_before('Class[proxysql::install]') }
          it { is_expected.to contain_class('proxysql::install').that_comes_before('Class[proxysql::config]') }
          it { is_expected.to contain_class('proxysql::config').that_comes_before('Class[proxysql::service]') }
          it { is_expected.to contain_class('proxysql::service').that_comes_before('Class[proxysql::admin_credentials]') }
          it { is_expected.to contain_class('proxysql::admin_credentials').that_comes_before('Class[proxysql::reload_config]') }
          it { is_expected.to contain_class('proxysql::admin_credentials').that_requires('Class[mysql::client::install]') }
          it { is_expected.to contain_class('proxysql::reload_config').that_comes_before('Class[proxysql::configure]') }
          it { is_expected.to contain_class('proxysql::reload_config').that_requires('Class[mysql::client::install]') }
          it { is_expected.to contain_class('proxysql::configure') }

          it { is_expected.to contain_class('proxysql::install').that_notifies('Class[proxysql::service]') }
          it { is_expected.to contain_class('proxysql::service').that_subscribes_to('Class[proxysql::install]') }

          it { is_expected.to contain_class('mysql::client').with(bindings_enable: false) }

          if facts[:os]['family'] == 'RedHat'
            it { is_expected.to contain_yumrepo('proxysql_2_7').with_baseurl("http://repo.proxysql.com/ProxySQL/proxysql-2.7.x/centos/#{facts[:os]['release']['major']}") }
            it { is_expected.to contain_yumrepo('proxysql_repo').with_ensure('absent') }
            it { is_expected.to contain_yumrepo('proxysql_2_6').with_ensure('absent') }
            it { is_expected.to contain_yumrepo('proxysql_2_5').with_ensure('absent') }
            it { is_expected.to contain_yumrepo('proxysql_2_4').with_ensure('absent') }
            it { is_expected.to contain_yumrepo('proxysql_2_3').with_ensure('absent') }
            it { is_expected.to contain_yumrepo('proxysql_2_2').with_ensure('absent') }
          end

          it do
            is_expected.to contain_package('proxysql').with(ensure: 'installed',
                                                            install_options: [])
          end

          sys_user = 'proxysql'
          sys_group = 'proxysql'

          admin_socket = '/tmp/proxysql_admin.sock'
          my_cnf_path = '/root/.my.cnf'

          it do
            is_expected.to contain_file('proxysql-config-file').with(ensure: 'file',
                                                                     owner: sys_user,
                                                                     group: sys_group,
                                                                     mode: '0640',
                                                                     path: '/etc/proxysql.cnf')
          end

          it do
            is_expected.to contain_file('proxysql-datadir').with(ensure: 'directory',
                                                                 owner: sys_user,
                                                                 group: sys_group,
                                                                 mode: '0600',
                                                                 path: '/var/lib/proxysql')
          end

          it do
            is_expected.to contain_file('root-mycnf-file').with(ensure: 'file',
                                                                owner: sys_user,
                                                                group: sys_group,
                                                                mode: '0400',
                                                                path: my_cnf_path)
          end

          it do
            is_expected.to contain_service('proxysql').with(ensure: 'running',
                                                            enable: true)
          end

          it { is_expected.to contain_service('proxysql').with_hasstatus(true) }
          it { is_expected.to contain_service('proxysql').with_hasrestart(true) }

          it do
            is_expected.to contain_exec('wait_for_admin_socket_availability_no_my_cnf').with(
              command: "mysql -u admin -S #{admin_socket} -e 'SELECT 1'",
              unless: "test -f #{my_cnf_path}",
              environment: ['MYSQL_PWD=admin'],
              tries: '10',
              try_sleep: '2',
              subscribe: 'Service[proxysql]',
              refreshonly: true,
              path: '/bin:/usr/bin',
            )
          end

          it do
            is_expected.to contain_exec('wait_for_admin_socket_availability_with_my_cnf').with(
              command: "mysql --defaults-extra-file=#{my_cnf_path} -e 'SELECT 1'",
              onlyif: "test -f #{my_cnf_path}",
              tries: '10',
              try_sleep: '2',
              subscribe: 'Service[proxysql]',
              refreshonly: true,
              path: '/bin:/usr/bin',
            )
          end
        end

        context 'with parameter datadir_mode set' do
          let(:params) { { 'datadir_mode' => '0644' } }

          it { is_expected.to contain_file('proxysql-datadir').with_mode('0644') }
        end

        context 'with an existing 2.6.x installation (proxysql_version fact set)' do
          let(:facts) { facts.merge(proxysql_version: '2.6.6-3-g4b9b4a4') }

          it { is_expected.to compile.with_all_deps }

          if facts[:os]['family'] == 'RedHat'
            it { is_expected.to contain_yumrepo('proxysql_2_6').with_baseurl("http://repo.proxysql.com/ProxySQL/proxysql-2.6.x/centos/#{facts[:os]['release']['major']}") }
            it { is_expected.not_to contain_yumrepo('proxysql_2_7') }
            it { is_expected.not_to contain_yumrepo('proxysql_3_0') }
          else
            it { is_expected.to contain_apt__source('proxysql_repo').with_location("http://repo.proxysql.com/ProxySQL/proxysql-2.6.x/#{facts[:os]['distro']['codename']}/") }
          end
        end

        if facts[:os]['family'] == 'RedHat'
          describe 'manage_selinux' do
            context 'on systems with selinux enabled' do
              let(:facts) do
                facts.deep_merge(
                  os: { selinux: { current_mode: 'enforcing' } },
                )
              end

              context 'by default' do
                it { is_expected.to contain_class('proxysql::selinux') }
              end

              context 'when manage_selinux is `false`' do
                let(:params) { { 'manage_selinux' => false } }

                it { is_expected.not_to contain_class('proxysql::selinux') }
              end
            end
          end
        end
      end
    end
  end

  context 'on releases without an upstream 2.7.x repository' do
    on_supported_os(
      supported_os: [
        { 'operatingsystem' => 'Debian', 'operatingsystemrelease' => ['13'] },
        { 'operatingsystem' => 'CentOS', 'operatingsystemrelease' => ['10'] },
      ],
    ).each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        context 'on a fresh install (no proxysql_version fact)' do
          it { is_expected.to compile.with_all_deps }

          if facts[:os]['family'] == 'RedHat'
            it { is_expected.to contain_yumrepo('proxysql_3_0').with_baseurl('http://repo.proxysql.com/ProxySQL/proxysql-3.0.x/centos/10') }
            it { is_expected.not_to contain_yumrepo('proxysql_2_7') }
          else
            it { is_expected.to contain_apt__source('proxysql_repo').with_location('http://repo.proxysql.com/ProxySQL/proxysql-3.0.x/trixie/') }
          end
        end

        context 'with an explicit 2.7.x version' do
          let(:params) { { 'version' => '2.7.1' } }

          if facts[:os]['family'] == 'RedHat'
            it { is_expected.to contain_yumrepo('proxysql_2_7').with_baseurl('http://repo.proxysql.com/ProxySQL/proxysql-2.7.x/centos/10') }
          else
            it { is_expected.to contain_apt__source('proxysql_repo').with_location('http://repo.proxysql.com/ProxySQL/proxysql-2.7.x/trixie/') }
          end
        end
      end
    end
  end
end
