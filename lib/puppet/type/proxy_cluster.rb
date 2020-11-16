# This has to be a separate type to enable collecting
Puppet::Type.newtype(:proxy_cluster) do
  @doc = 'Manage a ProxySQL cluster.'

  ensurable

  autorequire(:file) { "#{Facter.value(:proxysql_mycnf_file_name)}" }
  autorequire(:class) { 'mysql::client' }
  autorequire(:service) { 'proxysql' }

  validate do
    raise('name parameter is required.') if (self[:ensure] == :present) && self[:name].nil?
    raise('hostname parameter is required.') if (self[:ensure] == :present) && self[:hostname].nil?
    raise('port parameter is required.') if (self[:ensure] == :present) && self[:port].nil?
  end

  newparam(:name, namevar: true) do
    desc 'name for cluster to manage.'
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

  newproperty(:hostname) do
    desc 'The hostname of the server.'
    newvalue(%r{\w+})
  end

  newproperty(:port) do
    desc 'The port of the server.'
    newvalue(%r{\d+})
  end

  newproperty(:weight) do
    desc 'Currently unused, but in the roadmap for future enhancements.'
    newvalue(%r{\d+})
  end

  newproperty(:comment) do
    desc 'free form comment field.'
    newvalue(%r{[\w+]})
  end
end
