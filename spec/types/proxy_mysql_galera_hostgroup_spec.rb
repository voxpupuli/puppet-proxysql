require 'spec_helper'

describe 'proxy_mysql_galera_hostgroup' do
  let :title do
    '1-2-3-4'
  end

  it { is_expected.to be_valid_type }
  it { is_expected.to be_valid_type.with_provider(:proxysql) }
  it { is_expected.to be_valid_type.with_parameters(%w[writer_hostgroup backup_writer_hostgroup reader_hostgroup offline_hostgroup load_to_runtime save_to_disk]) }
  it { is_expected.to be_valid_type.with_properties(%w[active max_writers writer_is_also_reader max_transactions_behind comment]) }
end
