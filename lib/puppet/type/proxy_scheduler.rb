Puppet::Type.newtype(:proxy_scheduler) do
  @doc = 'Manage a ProxySQL scheduler entry.'

  ensurable

  autorequire(:file) { '/root/.my.cnf' }
  autorequire(:class) { 'mysql::client' }
  autorequire(:service) { 'proxysql' }

  validate do
    raise('scheduler_id parameter is required.') if self[:scheduler_id].nil?
    raise('filename parameter is required.') if (self[:ensure] == :present) && self[:filename].nil?
    raise('name must match \'scheduler-\'<scheduler_id> format') if self[:name] != "scheduler-#{self[:scheduler_id]}"
  end

  newparam(:name, namevar: true) do
    desc 'scheduler name'
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

  newproperty(:scheduler_id) do
    desc 'The id of the scheduler entry.'
    newvalue(%r{\d+})
  end

  newproperty(:active) do
    desc 'Is the scheduler active or not.'
    newvalue(%r{[01]})
  end

  newproperty(:interval_ms) do
    desc 'How often (in millisecond) the job will be started.'
    newvalue(%r{\d+})
  end

  newproperty(:filename) do
    desc 'Filename of the script to run. (required)'
    newvalue(%r{\w+})
  end

  newproperty(:arg1) do
    desc 'optional argument to pass to the script.'
    newvalue(%r{[\w+]})
  end

  newproperty(:arg2) do
    desc 'optional argument to pass to the script.'
    newvalue(%r{[\w+]})
  end

  newproperty(:arg3) do
    desc 'optional argument to pass to the script.'
    newvalue(%r{[\w+]})
  end

  newproperty(:arg4) do
    desc 'optional argument to pass to the script.'
    newvalue(%r{[\w+]})
  end

  newproperty(:arg5) do
    desc 'optional argument to pass to the script.'
    newvalue(%r{[\w+]})
  end

  newproperty(:comment) do
    desc 'optional comment.'
    newvalue(%r{[\w+]})
  end
end
