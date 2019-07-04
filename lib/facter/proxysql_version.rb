Facter.add(:proxysql_version) do
  confine kernel: 'Linux'
  setcode do
    if Facter::Util::Resolution.which('proxysql')
      proxysql_version = Facter::Util::Resolution.exec('proxysql --version 2>&1')
      %r{ProxySQL version (\d+\.\d+\.\d+.*),}.match(proxysql_version)[1]
    end
  end
end
