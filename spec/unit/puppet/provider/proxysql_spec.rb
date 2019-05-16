require 'spec_helper'

provider_class = Puppet::Type.type(:proxy_mysql_galera_hostgroup).provider(:proxysql)

describe provider_class do
  it 'has an `instances` method' do
    expect(described_class).to respond_to :instances
  end
  it 'has an `prefetch` method' do
    expect(described_class).to respond_to :prefetch
  end

  describe 'instances' do
    context 'when there are no hostgroups' do
      before do
        allow(described_class).to receive(:mysql).with(
          [
            '-NBe',
            'SELECT `writer_hostgroup`,`backup_writer_hostgroup`,`reader_hostgroup`,`offline_hostgroup`,`active`,`max_writers`,`writer_is_also_reader`,`max_transactions_behind`,`comment` FROM `mysql_galera_hostgroups`'
          ]
        ).and_return('')
      end
      it 'returns no resources' do
        expect(described_class.instances.size).to eq(0)
      end
    end
    context 'when there is 1 hostgroup' do
      before do
        allow(described_class).to receive(:mysql).with(
          [
            '-NBe',
            'SELECT `writer_hostgroup`,`backup_writer_hostgroup`,`reader_hostgroup`,`offline_hostgroup`,`active`,`max_writers`,`writer_is_also_reader`,`max_transactions_behind`,`comment` FROM `mysql_galera_hostgroups`'
          ]
        ).and_return('1	2	3	4	1	1	0	0	Galera Replication Group 1')
      end
      it 'returns 1 resource' do
        expect(described_class.instances.size).to eq(1)
      end
      it 'returns the resource 1-2-3-4' do
        expect(described_class.instances[0].instance_variable_get('@property_hash')).to eq(provider: :proxysql,
                                                                                           ensure:    :present,
                                                                                           name:      '1-2-3-4',
                                                                                           writer_hostgroup: 1,
                                                                                           backup_writer_hostgroup: 2,
                                                                                           reader_hostgroup: 3,
                                                                                           offline_hostgroup: 4,
                                                                                           active: 1,
                                                                                           writer_is_also_reader: 0,
                                                                                           max_writers: 1,
                                                                                           comment: 'Galera Replication Group 1',
                                                                                           max_transactions_behind: 0)
      end
    end
    context 'when there are 2 hostgroups' do
      before do
        allow(described_class).to receive(:mysql).with(
          [
            '-NBe',
            'SELECT `writer_hostgroup`,`backup_writer_hostgroup`,`reader_hostgroup`,`offline_hostgroup`,`active`,`max_writers`,`writer_is_also_reader`,`max_transactions_behind`,`comment` FROM `mysql_galera_hostgroups`'
          ]
        ).and_return("1	2	3	4	1	1	0	0	Galera Replication Group 1\n5	6	7	8	1	2	0	0	another group")
      end
      it 'returns 2 resources' do
        expect(described_class.instances.size).to eq(2)
      end
    end
  end
end
