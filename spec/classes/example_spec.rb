require 'spec_helper'

describe 'proxysql' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "proxysql class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('proxysql::params') }
          it { is_expected.to contain_class('proxysql::install').that_comes_before('proxysql::config') }
          it { is_expected.to contain_class('proxysql::config') }
          it { is_expected.to contain_class('proxysql::service').that_subscribes_to('proxysql::config') }

          it { is_expected.to contain_service('proxysql') }
          it { is_expected.to contain_package('proxysql').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'proxysql class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('proxysql') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
