# frozen_string_literal: true

require 'spec_helper'

describe 'proxy_global_variable' do
  let :title do
    'some-variable'
  end

  let(:params) do
    {
      value: 'some-value',
    }
  end

  it { is_expected.to be_valid_type }
  it { is_expected.to be_valid_type.with_provider(:proxysql) }
  it { is_expected.to be_valid_type.with_parameters(%w[name load_to_runtime save_to_disk]) }
end
