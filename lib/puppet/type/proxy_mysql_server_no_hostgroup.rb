# This has to be a separate type to enable collecting
Puppet::Type.newtype(:proxy_mysql_server_no_hostgroup) do
  @doc = 'Manage a ProxySQL mysql_server.'

  ensurable

  autorequire(:file) { '/root/.my.cnf' }
  autorequire(:class) { 'mysql::client' }
  autorequire(:service) { 'proxysql' }

  validate do
    raise('hostname parameter is required.') if (self[:ensure] == :present) && self[:hostname].nil?
    raise('port parameter is required.') if (self[:ensure] == :present) && self[:port].nil?
    raise('hostgroup_id parameter is required.') if (self[:ensure] == :present) && self[:hostgroup_id].nil?
    raise('name must match hostname and port') if self[:name] != "#{self[:hostname]}:#{self[:port]}"
  end

  newparam(:name, namevar: true) do
    desc 'name for server to manage.'
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

  newparam(:hostgroup_id) do
    desc 'The hostgroup of the server.'
    defaultto 0
    newvalues(%r{\d+})
  end

  newproperty(:hostname) do
    desc 'The hostname of the server.'
    defaultto :localhost
    newvalue(%r{\w+})
  end

  newproperty(:port) do
    desc 'The port of the server.'
    defaultto 3306
    newvalue(%r{\d+})
  end

  newproperty(:status) do
    desc 'Server status.'
    newvalues(:ONLINE, :SHUNNED, :OFFLINE_SOFT, :OFFLINE_HARD)
  end

  newproperty(:weight) do
    desc 'the bigger the weight of a server relative to other weights, the higher the probability of the server to be chosen from a hostgroup'
    newvalue(%r{\d+})
  end

  newproperty(:compression) do
    desc 'if the value is greater than 0, new connections to that server will use compression'
    newvalue(%r{\d+})
  end

  newproperty(:max_connections) do
    desc 'the maximum number of connections ProxySQL will open to this backend server. Even though this server will have the highest weight, no new connections will be opened to it once this limit is hit. Please ensure that the backend is configured with a correct value of max_connections to avoid that ProxySQL will try to go beyond that limit'
    newvalue(%r{\d+})
  end

  newproperty(:max_replication_lag) do
    desc 'if greater and 0, ProxySQL will reguarly monitor replication lag and if it goes beyond such threshold it will temporary shun the host until replication catch ups'
    newvalue(%r{\d+})
  end

  newproperty(:use_ssl) do
    desc 'if set to 1, connections to the backend will use SSL'
    newvalue(%r{[01]})
  end

  newproperty(:max_latency_ms) do
    desc 'ping time is regularly monitored. If a host has a ping time greater than max_latency_ms it is excluded from the connection pool (although the server stays ONLINE)'
    newvalue(%r{[\d+]})
  end

  newproperty(:comment) do
    desc 'text field that can be used for any purposed defined by the user. Could be a description of what the host stores, a reminder of when the host was added or disabled, or a JSON processed by some checker script.'
    newvalue(%r{[\w+]})
  end
end
