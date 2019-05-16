require 'spec_helper'
require 'puppet'

describe Puppet::Type.type(:proxy_mysql_galera_hostgroup) do
  describe 'parameters' do
    [:name, :provider, :writer_hostgroup, :backup_writer_hostgroup, :reader_hostgroup, :offline_hostgroup, :load_to_runtime, :save_to_disk].each do |param|
      it "should have a #{param} parameter" do
        expect(described_class.attrtype(param)).to eq(:param)
      end
    end
    [:ensure, :active, :max_writers, :writer_is_also_reader, :max_transactions_behind, :comment].each do |prop|
      it "should have a #{prop} property" do
        expect(described_class.attrtype(prop)).to eq(:property)
      end
    end
  end

  describe 'namevars' do
    it 'has 5 namevars' do
      expect(described_class.key_attributes.size).to eq(5)
    end
    [:name, :writer_hostgroup, :backup_writer_hostgroup, :reader_hostgroup, :offline_hostgroup].each do |param|
      it "'#{param}' should be a namevar" do
        expect(described_class.key_attributes).to include(param)
      end
    end
  end

  describe 'name' do
    let(:hostgroup) { described_class.new(title: 'resourcetitle', writer_hostgroup: 1, backup_writer_hostgroup: 2, reader_hostgroup: 3, offline_hostgroup: 4) }

    it 'is munged to <writer_hostgroup>-<backup_writer_hostgroup>-<reader_hostgroup>-<offline_hostgroup>' do
      expect(hostgroup[:name]).to eq('1-2-3-4')
    end
  end

  describe 'autorequiring' do
    let(:mysql_settings_file) { Puppet::Type.type(:file).new(name: '/root/.my.cnf', ensure: :file) }
    let(:proxysql_service) { Puppet::Type.type(:service).new(name: 'proxysql', ensure: 'running') }
    let(:catalog) { Puppet::Resource::Catalog.new }
    let(:resource) { described_class.new(title: 'resourcetitle', writer_hostgroup: 1, backup_writer_hostgroup: 2, reader_hostgroup: 3, offline_hostgroup: 4) }

    it 'autorequires the mysql settings file' do
      catalog.add_resource mysql_settings_file
      catalog.add_resource resource
      req = resource.autorequire
      expect(req.find { |relationship| relationship.source == mysql_settings_file && relationship.target == resource }).not_to be_nil
    end

    it 'autorequires the proxysql service' do
      catalog.add_resource proxysql_service
      catalog.add_resource resource
      req = resource.autorequire
      expect(req.find { |relationship| relationship.source == proxysql_service && relationship.target == resource }).not_to be_nil
    end

    xit 'should autorequire the class mysql::client' do
    end
  end
end
