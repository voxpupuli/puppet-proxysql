Facter.add(:proxysql_mycnf_file_name) do
  setcode 'cat /root/.proxysql_mycnf_file_name'
end
