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
          
        end
      end
    end
  end

end
