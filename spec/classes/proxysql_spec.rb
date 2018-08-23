require 'spec_helper'

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
          it { is_expected.to contain_anchor('proxysql::begin').that_comes_before('Class[proxysql::repo]') }
          it { is_expected.to contain_class('proxysql::repo').that_comes_before('Class[proxysql::install]') }
          it { is_expected.to contain_class('proxysql::install').that_comes_before('Class[proxysql::config]') }
          it { is_expected.to contain_class('proxysql::config').that_comes_before('Class[proxysql::service]') }
          it { is_expected.to contain_class('proxysql::service').that_comes_before('Class[proxysql::admin_credentials]') }
          it { is_expected.to contain_class('proxysql::admin_credentials').that_comes_before('Class[proxysql::cluster]') }
          it { is_expected.to contain_class('proxysql::cluster').that_comes_before('Anchor[proxysql::end]') }


          it { is_expected.to contain_class('proxysql::service').that_subscribes_to('Class[proxysql::install]') }
          
          it { is_expected.to contain_anchor('proxysql::end') }
          

          it { is_expected.to contain_class('proxysql::install').that_notifies('Class[proxysql::service]') }

          it { is_expected.to contain_class('mysql::client').with(bindings_enable: false) }

          it do
            is_expected.to contain_package('proxysql').with(ensure: 'installed',
                                                            install_options: [])
          end

          let(:sys_user) { 'root' }
          let(:sys_group) { 'root' }

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
                                                            enable: true,
                                                            hasstatus: true,
                                                            hasrestart: true)
          end

          it do
            is_expected.to contain_exec('wait_for_admin_socket_to_open').with(
              command:   'test -S /tmp/proxysql_admin.sock',
              unless:    'test -S /tmp/proxysql_admin.sock',
              tries:     3,
              try_sleep: 10,
              require:   'Service[proxysql]',
              path:      '/bin:/usr/bin'
            )
          end
        end
      end
    end
  end
end
