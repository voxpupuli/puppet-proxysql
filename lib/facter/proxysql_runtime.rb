# frozen_string_literal: true

Facter.add(:proxysql_runtime) do
  client = nil

  confine :proxysql_version do |version|
    version =~ %r{^2}
  end

  confine do
    begin
      require 'mysql2'
    rescue LoadError
      next
    end

    begin
      client = Mysql2::Client.new(default_file: '/root/.my.cnf')
    rescue Mysql2::Error::ConnectionError => e
      Facter.debug(e.inspect)
    end
    client
  end

  setcode do
    fact = {}
    [
      # tables that might include unencrypted credentials have not been included here.
      'runtime_mysql_servers',
      'runtime_mysql_aws_aurora_hostgroups',
      'runtime_mysql_galera_hostgroups',
      'runtime_mysql_group_replication_hostgroups',
      'runtime_mysql_query_rules',
      'runtime_mysql_query_rules_fast_routing',
      'runtime_mysql_replication_hostgroups',
      'runtime_proxysql_servers'
    ].each do |table|
      results = client.query("SELECT * FROM #{table}")
      fact[table] = results.map { |row| row }
    end
    fact
  end
end
