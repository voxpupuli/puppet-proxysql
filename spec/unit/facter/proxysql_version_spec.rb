# frozen_string_literal: true

require 'spec_helper'

describe Facter::Util::Fact.to_s do
  before do
    Facter.clear
  end

  describe 'proxysql_version' do
    before do
      allow(Facter::Core::Execution).to receive(:which).with('proxysql').and_return(true)
      allow(Facter::Core::Execution).to receive(:execute).with(a_string_including('uname -m &&'), any_args).and_return("x86_64\nlocalhost\nx86_64\n5.15.0\nLinux\n#1 SMP")
      allow(Facter::Core::Execution).to receive(:execute).with('proxysql --version 2>&1').and_return('ProxySQL version 2.0.4-116-g7d371cf2, codename Truls')
    end

    it {
      expect(Facter.fact(:proxysql_version).value).to eq('2.0.4-116-g7d371cf2')
    }
  end
end
