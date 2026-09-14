# frozen_string_literal: true

Facter.add(:proxysql_version) do
  confine kernel: 'Linux'
  setcode do
    if Facter::Core::Execution.which('proxysql')
      proxysql_version = Facter::Core::Execution.execute('proxysql --version 2>&1')
      %r{ProxySQL version (\d+\.\d+\.\d+.*),}.match(proxysql_version)[1]
    end
  end
end
