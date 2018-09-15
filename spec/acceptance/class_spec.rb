require 'spec_helper_acceptance'

describe 'proxysql class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'proxysql': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('proxysql') do
      it { is_expected.to be_installed }
    end

    describe service('proxysql') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end

  context 'extended testing' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'proxysql':
        listen_port              => 3306,
        admin_username           => 'admin',
        admin_password           => Sensitive('654321'),
        monitor_username         => 'monitor',
        monitor_password         => Sensitive('123456'),
        override_config_settings => {
          mysql_variables => {
            'monitor_writer_is_also_reader' => false,
          }
        },
      }

      proxy_mysql_replication_hostgroup { '10-20':
        ensure           => 'present',
        writer_hostgroup => 10,
        reader_hostgroup => 20,
        comment          => 'Test MySQL Cluster 10-20',
      }

      proxy_mysql_replication_hostgroup { '10-30':
        ensure           => 'absent',
        writer_hostgroup => 10,
        reader_hostgroup => 30,
        comment          => 'Test MySQL Cluster 10-30',
      }

      proxy_mysql_user { 'tester':
        ensure            => 'absent',
        password          => mysql_password('tester'),
        default_hostgroup => 1,
        default_schema    => 'test',
      }

      proxy_mysql_user { 'tester1':
        ensure            => 'present',
        password          => mysql_password('tester123'),
        default_hostgroup => 1,
        default_schema    => 'test1',
      }

      proxy_mysql_user { 'tester2':
        ensure            => 'present',
        password          => mysql_password('tester2'),
        default_hostgroup => 2,
        default_schema    => 'test2',
        load_to_runtime   => false,
      }

      proxy_mysql_server { '127.0.0.1:3307-1':
        ensure       => 'present',
        hostname     => '127.0.0.1',
        port         => 3307,
        hostgroup_id => 1,
        status       => 'ONLINE',
        weight       => 1000,
        comment      => 'localhost:3307-1',
      }

      proxy_mysql_server { '127.0.0.1:3307-2':
        ensure       => 'present',
        hostname     => '127.0.0.1',
        port         => 3307,
        hostgroup_id => 2,
        weight       => 100,
        comment      => 'localhost:3307-2',
      }

      proxy_mysql_query_rule { 'mysql_query_rule-1':
        rule_id               => 1,
        active                => 1,
        username              => 'tester1',
        match_pattern         => '^SELECT',
        destination_hostgroup => 2,
        apply                 => 1,
      }

      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('proxysql') do
      it { is_expected.to be_installed }
    end

    describe service('proxysql') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe command("mysql -NB -e \"SELECT comment FROM mysql_servers WHERE hostname = '127.0.0.1' AND port = 3307 AND hostgroup_id = 1;\"") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match '^localhost:3307-1$' }
    end

    describe command("mysql -NB -e \"SELECT comment FROM mysql_servers WHERE hostname = '127.0.0.1' AND port = 3307 AND hostgroup_id = 2;\"") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match '^localhost:3307-2$' }
    end

    describe command("mysql -NB -e 'SELECT comment FROM mysql_replication_hostgroups WHERE writer_hostgroup = 10 AND reader_hostgroup = 20;'") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match '^Test MySQL Cluster 10-20$' }
    end

    describe command("mysql -NB -e 'SELECT comment FROM mysql_replication_hostgroups WHERE writer_hostgroup = 10 AND reader_hostgroup = 30;'") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to eq('') }
    end

    describe command("mysql -NB -e \"SELECT username FROM mysql_users WHERE username = 'tester';\"") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to eq('') }
    end

    describe command("mysql -NB -e 'SELECT username FROM mysql_users;'") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) do
        is_expected.to match 'tester1'
        is_expected.to match 'tester2'
      end
    end

    describe command("mysql -NB -e \"SELECT default_schema FROM mysql_users WHERE username = 'tester1';\"") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match '^test1$' }
    end

    describe command("mysql -NB -e \"SELECT default_hostgroup FROM mysql_users WHERE username = 'tester1';\"") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match '^1$' }
    end

    describe command("mysql -NB -e \"SELECT default_schema FROM mysql_users WHERE username = 'tester2';\"") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match '^test2$' }
    end

    describe command("mysql -NB -e \"SELECT default_hostgroup FROM mysql_users WHERE username = 'tester2';\"") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match '^2$' }
    end

    describe command("mysql -NB -e 'SELECT username FROM runtime_mysql_users;'") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match '^tester1$' }
    end

    describe command("mysql -NB -e \"SELECT username FROM runtime_mysql_users WHERE username = 'tester2';\"") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to eq('') }
    end

    describe command("mysql -NB -e 'SELECT username FROM mysql_query_rules WHERE rule_id = 1;'") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match '^tester1$' }
    end

    describe command("mysql -NB -e 'SELECT match_pattern FROM mysql_query_rules WHERE rule_id = 1;'") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match '^\^SELECT$' }
    end
  end
end
