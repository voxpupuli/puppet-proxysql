# frozen_string_literal: true

require 'spec_helper'

valid_mysql_galera_hostgroups = [
  {
    'galera hostgroup 1' => {
      'writer' => 1,
      'backup' => 2,
      'reader' => 3,
      'offline' => 4,
      'active' => 1,
      'writers' => 10,
      'writer_is_reader' => 2,
      'max_transactions' => 1000
    }
  },
  {
    'galera hostgroup 2' => {
      'writer' => 10,
      'backup' => 20,
      'reader' => 30,
      'offline' => 40,
      'active' => 1,
      'writers' => 1,
      'writer_is_reader' => 0
    }
  }
]
describe 'Proxysql::GaleraHostgroup' do
  it { is_expected.to allow_value(valid_mysql_galera_hostgroups) }
end
