# frozen_string_literal: true

# This has to be a separate type to enable collecting
Puppet::Type.newtype(:proxy_mysql_replication_hostgroup) do
  @doc = 'Manage a ProxySQL mysql_replication_hostgroup.'

  ensurable

  autorequire(:file) { '/root/.my.cnf' }
  autorequire(:class) { 'mysql::client' }
  autorequire(:service) { 'proxysql' }

  validate do
    raise('writer_hostgroup parameter is required.') if (self[:ensure] == :present) && self[:writer_hostgroup].nil?
    raise('reader_hostgroup parameter is required.') if (self[:ensure] == :present) && self[:reader_hostgroup].nil?
    raise('name must match writer_hostgroup-reader_hostgroup parameters') if self[:name] != "#{self[:writer_hostgroup]}-#{self[:reader_hostgroup]}"
  end

  newparam(:name, namevar: true) do
    desc 'name to describe the hostgroup config'
  end

  newparam(:load_to_runtime) do
    desc 'Load this entry to the active runtime.'
    defaultto :true
    newvalues(:true, :false)
  end

  newparam(:save_to_disk) do
    desc 'Perist this entry to the disk.'
    defaultto :true
    newvalues(:true, :false)
  end

  newproperty(:writer_hostgroup) do
    desc 'Writer hostgroup.'
    newvalue(%r{\d+})
  end

  newproperty(:reader_hostgroup) do
    desc 'Reader hostgroup.'
    newvalue(%r{\d+})
  end

  newproperty(:comment) do
    desc 'text field can be used to store any arbitrary data.'
    newvalue(%r{[\w+]})
  end
end
