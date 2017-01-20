require 'spec_helper'

describe 'proxysql' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "proxysql class without any parameters" do

          it { is_expected.to contain_class('proxysql') }
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('proxysql::params') }
          it { is_expected.to contain_class('proxysql::install').that_comes_before('Class[proxysql::config]') }
          it { is_expected.to contain_class('proxysql::config').that_comes_before('Class[proxysql::service]') }
          it { is_expected.to contain_class('proxysql::service').that_subscribes_to('Class[proxysql::install]') }


          it { is_expected.to contain_class('mysql::client').with( :bindings_enable => false)}

          it { is_expected.to contain_package('proxysql').with_ensure('present') }

          it { is_expected.to contain_file('proxysql-config-file').with({
            :ensure => 'file',
            :owner  => 'root',
            :group  => 'root',
            :mode   => '0640',
            :path   => '/etc/proxysql.cnf'
          }) }

          it { is_expected.to contain_file('proxysql-datadir').with({
            :ensure => 'directory',
            :owner  => 'root',
            :group   => 'root',
            :mode   => '0600',
            :path   => '/var/lib/proxysql'
          }) }

          it { is_expected.to contain_file('root-mycnf-file').with({
            :ensure => 'file',
            :owner  => 'root',
            :group  => 'root',
            :mode   => '0400',
            :path   => '/root/.my.cnf'
          }) }

          it { is_expected.to contain_service('proxysql').with({
            :ensure     => 'running',
            :enable     => true,
            :hasstatus  => true,
            :hasrestart => true,
          }) }

          it { is_expected.to contain_proxy_global_variable('admin-admin_credentials').with({
            :value      => 'admin:admin'
          }) }

          it { is_expected.to contain_proxy_global_variable('admin-mysql_ifaces').with({
            :value      => '127.0.0.1:6032;/tmp/proxysql_admin.sock'
          }) }

          it { is_expected.to contain_proxy_global_variable('admin-refresh_interval').with({
            :value      => '2000'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-threads').with({
            :value      => '4'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-max_connections').with({
            :value      => '2048'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-default_query_delay').with({
            :value      => '0'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-default_query_timeout').with({
            :value      => '36000000'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-have_compress').with({
            :value      => 'true'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-poll_timeout').with({
            :value      => '2000'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-interfaces').with({
            :value      => '0.0.0.0:6033;/tmp/proxysql.sock'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-default_schema').with({
            :value      => 'information_schema'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-stacksize').with({
            :value      => '1048576'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-server_version').with({
            :value      => '5.5.30'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-connect_timeout_server').with({
            :value      => '3000'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-monitor_history').with({
            :value      => '600000'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-monitor_connect_interval').with({
            :value      => '60000'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-monitor_ping_interval').with({
            :value      => '10000'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-monitor_read_only_interval').with({
            :value      => '1500'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-monitor_read_only_timeout').with({
            :value      => '500'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-ping_interval_server_msec').with({
            :value      => '120000'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-ping_timeout_server').with({
            :value      => '500'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-commands_stats').with({
            :value      => 'true'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-sessions_sort').with({
            :value      => 'true'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-connect_retries_on_failure').with({
            :value      => '10'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-monitor_username').with({
            :value      => 'monitor'
          }) }

          it { is_expected.to contain_proxy_global_variable('mysql-monitor_password').with({
            :value      => 'monitor'
          }) }
        end
      end
    end
  end

end
