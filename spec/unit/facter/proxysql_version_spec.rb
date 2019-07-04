require 'spec_helper'

describe Facter::Util::Fact.to_s do
  before do
    Facter.clear
  end

  describe 'proxysql_version' do
    before do
      allow(Facter::Util::Resolution).to receive(:which).with('proxysql').and_return(true)
      allow(Facter::Util::Resolution).to receive(:exec).with('proxysql --version 2>&1').and_return('ProxySQL version 2.0.4-116-g7d371cf2, codename Truls')
    end
    it {
      expect(Facter.fact(:proxysql_version).value).to eq('2.0.4-116-g7d371cf2')
    }
  end
end
