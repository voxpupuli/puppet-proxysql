# frozen_string_literal: true

require 'spec_helper'

describe 'proxy_mysql_group_replication_hostgroup' do
  let :title do
    'some-title'
  end

  let(:params) do
    {
      ensure: 'present',
      name: '10-20-30-40',
      writer_hostgroup: 10,
      backup_writer_hostgroup: 20,
      reader_hostgroup: 30,
      offline_hostgroup: 40
    }
  end

  context 'with ensure => present' do
    it { is_expected.to be_valid_type }
    it { is_expected.to be_valid_type.with_provider(:proxysql) }
    it { is_expected.to be_valid_type.with_parameters(%w[name load_to_runtime save_to_disk]) }
  end

  context 'with ensure => absent' do
    let(:params) do
      super().merge({ 'ensure' => 'absent' })
    end

    it { is_expected.to be_valid_type }
  end
end
