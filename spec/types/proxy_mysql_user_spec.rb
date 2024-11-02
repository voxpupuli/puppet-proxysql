# frozen_string_literal: true

require 'spec_helper'

describe 'proxy_mysql_user' do
  let :title do
    'some-title'
  end

  let(:params) do
    {
      ensure: 'present',
      password: 'somePassword'
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
