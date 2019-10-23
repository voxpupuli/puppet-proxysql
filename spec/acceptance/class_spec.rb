require 'spec_helper_acceptance'

describe 'proxysql class' do
  unless fact('os.release.major') == '18.04' # There are no proxysql 1.4 packages for bionic
    context 'version 1.4' do
      it 'works idempotently with no errors' do
        pp = <<-EOS
      class { 'proxysql':
        version => '1.4.16',
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

      describe command('proxysql --version') do
        its(:exit_status) { is_expected.to eq 0 }
        its(:stderr) { is_expected.to match %r{^ProxySQL version 1\.4\.} }
      end
    end
  end

  context 'Upgrading to version 2.0' do
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'proxysql':
        package_ensure => latest,
        version        => '2.0.7',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)

      # Run it again, this time relying on proxysql_version fact
      apply_manifest('class { \'proxysql\':}', catch_changes: true)
    end

    describe package('proxysql') do
      it { is_expected.to be_installed }
    end

    describe service('proxysql') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe command('proxysql --version') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{^ProxySQL version 2\.0\.} }
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

      proxy_mysql_group_replication_hostgroup { '5-2-10-11':
        ensure                  => 'present',
        reader_hostgroup        => 10,
        writer_hostgroup        => 5,
        backup_writer_hostgroup => 2,
        offline_hostgroup       => 11,
        comment                 => 'Test MySQL GR Cluster 5-2-10-11',
      }

      proxy_mysql_group_replication_hostgroup { '3-20-6-30':
        ensure                  => 'absent',
        reader_hostgroup        => 6,
        writer_hostgroup        => 3,
        backup_writer_hostgroup => 20,
        offline_hostgroup       => 30,
        comment                 => 'Test MySQL GR Cluster 3-20-6-30',
      }

      if $facts['proxysql_version'] =~ /^2/ {
        proxy_mysql_galera_hostgroup { '1-2-3-4':
          ensure                  => 'present',
          writer_hostgroup        => 1,
          backup_writer_hostgroup => 2,
          reader_hostgroup        => 3,
          offline_hostgroup       => 4,
          active                  => 1,
          max_writers             => 1,
          writer_is_also_reader   => 1,
          max_transactions_behind => 100,
          comment                 => 'Test MySQL Galera Cluster 1-2-3-4',
        }

        proxy_mysql_galera_hostgroup { '5-6-7-8':
          ensure                  => 'absent',
          writer_hostgroup        => 5,
          backup_writer_hostgroup => 6,
          reader_hostgroup        => 7,
          offline_hostgroup       => 8,
          max_transactions_behind => 100,
          comment                 => 'Test MySQL Galera Cluster 5-6-7-8',
        }
        proxy_mysql_galera_hostgroup { '9-10-11-12':
          ensure                  => 'present',
          comment                 => 'Test MySQL Galera Cluster 9-10-11-12',
        }
        proxy_mysql_galera_hostgroup { 'another galera hostgroup':
          ensure                  => 'present',
          writer_hostgroup        => 13,
          backup_writer_hostgroup => 14,
          reader_hostgroup        => 15,
          offline_hostgroup       => 16,
          comment                 => 'Test MySQL Galera Cluster 13-14-15-16',
        }
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

    if fact('proxysql_version') =~ %r{^2}
      describe command("mysql -NB -e 'SELECT comment FROM mysql_galera_hostgroups WHERE writer_hostgroup = 1 AND backup_writer_hostgroup = 2 AND reader_hostgroup = 3 AND offline_hostgroup = 4;'") do
        its(:exit_status) { is_expected.to eq 0 }
        its(:stdout) { is_expected.to match '^Test MySQL Galera Cluster 1-2-3-4$' }
      end

      describe command("mysql -NB -e 'SELECT comment FROM mysql_galera_hostgroups WHERE writer_hostgroup = 5 AND backup_writer_hostgroup = 6 AND reader_hostgroup = 7 AND offline_hostgroup = 8;'") do
        its(:exit_status) { is_expected.to eq 0 }
        its(:stdout) { is_expected.to eq('') }
      end

      describe command("mysql -NB -e 'SELECT comment FROM mysql_galera_hostgroups WHERE writer_hostgroup = 9;'") do
        its(:exit_status) { is_expected.to eq 0 }
        its(:stdout) { is_expected.to match '^Test MySQL Galera Cluster 9-10-11-12$' }
      end

      describe command("mysql -NB -e 'SELECT comment FROM mysql_galera_hostgroups WHERE writer_hostgroup = 13;'") do
        its(:exit_status) { is_expected.to eq 0 }
        its(:stdout) { is_expected.to match '^Test MySQL Galera Cluster 13-14-15-16$' }
      end
    end

    describe command("mysql -NB -e 'SELECT comment FROM mysql_group_replication_hostgroups WHERE writer_hostgroup = 5 AND backup_writer_hostgroup = 2 AND reader_hostgroup = 10 AND offline_hostgroup = 11;'") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match '^Test MySQL GR Cluster 5-2-10-11$' }
    end

    describe command("mysql -NB -e 'SELECT comment FROM mysql_group_replication_hostgroups WHERE writer_hostgroup = 6 AND backup_writer_hostgroup = 3 AND reader_hostgroup = 20 AND offline_hostgroup = 30;'") do
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
  context 'with restart => true' do
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'proxysql':
        restart                  => true,
        listen_port              => 3306,
        admin_username           => 'admin',
        admin_password           => Sensitive('654321'),
        monitor_username         => 'monitor',
        monitor_password         => Sensitive('123456'),
        override_config_settings => {
          mysql_variables => {
            'monitor_writer_is_also_reader' => true,
          }
        },
      }
      EOS
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
    describe service('proxysql') do
      it { is_expected.to be_running }
    end
  end
end
