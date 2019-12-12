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

          if facts[:osfamily] == 'RedHat'
            it { is_expected.to contain_yumrepo('proxysql_repo').with_baseurl("http://repo.proxysql.com/ProxySQL/proxysql-2.0.x/centos/#{facts[:operatingsystemmajrelease]}") }
          end

          it do
            is_expected.to contain_package('proxysql').with(ensure: 'installed',
                                                            install_options: [])
          end

          sys_user = 'proxysql'
          sys_group = 'proxysql'

          admin_socket = if facts[:operatingsystemrelease] == '18.04'
                           '/var/lib/proxysql/proxysql_admin.sock'
                         else
                           '/tmp/proxysql_admin.sock'
                         end

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
                                                                path: '/root/.my.cnf')
          end

          it do
            is_expected.to contain_service('proxysql').with(ensure: 'running',
                                                            enable: true)
          end

          unless (facts[:osfamily] == 'RedHat' && facts[:operatingsystemmajrelease] == '7') ||
                 (facts[:operatingsystem] == 'Ubuntu' && facts[:operatingsystemmajrelease] == '18.04') ||
                 (facts[:operatingsystem] == 'Debian' && facts[:operatingsystemmajrelease] =~ %r{^(9|10)$})
            it { is_expected.to contain_service('proxysql').with_hasstatus(true) }
            it { is_expected.to contain_service('proxysql').with_hasrestart(true) }
          end

          it do
            is_expected.to contain_exec('wait_for_admin_socket_to_open').with(
              command:   "test -S #{admin_socket}",
              unless:    "test -S #{admin_socket}",
              tries:     3,
              try_sleep: 10,
              require:   'Service[proxysql]',
              path:      '/bin:/usr/bin'
            )
          end
        end

        context 'with parameter datadir_mode set' do
          let(:params) { { 'datadir_mode' => '0644' } }

          it { is_expected.to contain_file('proxysql-datadir').with_mode('0644') }
        end

        if facts[:osfamily] == 'RedHat'
          describe 'manage_selinux' do
            context 'on systems with selinux enabled' do
              let(:facts) do
                facts.deep_merge(
                  os: { selinux: { current_mode: 'enforcing' } }
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
end
