# This has to be a separate type to enable collecting
Puppet::Type.newtype(:proxy_global_variable) do
  @doc = 'Manage a ProxySQL global variable.'

  autorequire(:class) { 'proxysql::admin_credentials' }
  autorequire(:class) { 'mysql::client' }
  autorequire(:service) { 'proxysql' }

  newparam(:name, namevar: true) do
    desc 'variable name'
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

  newproperty(:value) do
    desc 'variable value'
    newvalue(%r{.+})

    munge do |value|
      if value.is_a?(TrueClass)
        :true
      elsif value.is_a?(FalseClass)
        :false
      else
        value
      end
    end
  end
end
