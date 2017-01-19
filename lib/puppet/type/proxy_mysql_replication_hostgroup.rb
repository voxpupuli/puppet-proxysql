# This has to be a separate type to enable collecting
Puppet::Type.newtype(:proxy_mysql_replication_hostgroup) do
  @doc = 'Manage a ProxySQL mysql_replication_hostgroup.'

  ensurable

  autorequire(:file) { '/root/.my.cnf' }
  autorequire(:class) { 'mysql::client' }

  validate do
    fail('writer_hostgroup parameter is required.') if self[:ensure] == :present and self[:writer_hostgroup].nil?
    fail('reader_hostgroup parameter is required.') if self[:ensure] == :present and self[:reader_hostgroup].nil?
    fail('name must match writer_hostgroup-reader_hostgroup parameters') if self[:name] != "#{self[:writer_hostgroup]}-#{self[:reader_hostgroup]}"
  end

  newparam(:name, :namevar => true) do
    desc 'name to describe the hostgroup config'
  end

  newproperty(:writer_hostgroup) do
    desc 'writer_hostgroup.'
    newvalue(/\d+/)
  end

  newproperty(:reader_hostgroup) do
    desc 'Reader hostgroup.'
    newvalue(/\d+/)
  end

  newproperty(:comment) do
    desc "text field can be used to store any arbitrary data."
    newvalue(/[\w+]/)
  end

end
