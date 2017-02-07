Puppet::Type.newtype(:proxy_scheduler) do
  @doc = 'Manage a ProxySQL scheduler entry.'

  ensurable

  autorequire(:file) { '/root/.my.cnf' }
  autorequire(:class) { 'mysql::client' }
  autorequire(:service) { 'proxysql' }

  validate do
    fail('id parameter is required.') if self[:id].nil?
    fail('filename parameter is required.') if self[:ensure] == :present and self[:filename].nil?
    fail('name must match \'scheduler-\'<id> format') if self[:name] != "scheduler-#{self[:rule_id]}"
  end

  newparam(:name, :namevar => true) do
    desc 'scheduler name'
  end

  newproperty(:id) do
    desc 'The id of the scheduler entry.'
    newvalue(/\d+/)
  end

  newproperty(:active) do
    desc "Is the scheduler active or not."
    defaultto 0
    newvalue(/[01]/)
  end

  newproperty(:interval_ms) do
    desc 'How often (in millisecond) the job will be started.'
    defaultto 10000
    newvalue(/\d+/)
  end

  newproperty(:filename) do
    desc 'Filename of the script to run. (required)'
    newvalue(/\w+/)
  end

  newproperty(:arg1) do
    desc "optional argument to pass to the script."
    newvalue(/[\w+]/)
  end

  newproperty(:arg2) do
    desc "optional argument to pass to the script."
    newvalue(/[\w+]/)
  end

  newproperty(:arg3) do
    desc "optional argument to pass to the script."
    newvalue(/[\w+]/)
  end

  newproperty(:arg4) do
    desc "optional argument to pass to the script."
    newvalue(/[\w+]/)
  end

  newproperty(:arg5) do
    desc "optional argument to pass to the script."
    newvalue(/[\w+]/)
  end

  newproperty(:comment) do
    desc "optional comment."
    newvalue(/[\w+]/)
  end

end
