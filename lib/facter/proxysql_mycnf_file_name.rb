Facter.add(:proxysql_mycnf_file_name) do
  setcode do
    if File.exist? '/root/.proxysql_mycnf_file_name'
      Facter::Core::Execution.execute('cat /root/.proxysql_mycnf_file_name')
    else
      '/root/.my.cnf'
    end
  end
end
