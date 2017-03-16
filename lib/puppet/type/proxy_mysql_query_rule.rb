Puppet::Type.newtype(:proxy_mysql_query_rule) do
  @doc = 'Manage a ProxySQL mysql_query_rules entry.'

  ensurable

  autorequire(:file) { '/root/.my.cnf' }
  autorequire(:class) { 'mysql::client' }
  autorequire(:service) { 'proxysql' }

  validate do
    raise('rule_id parameter is required.') if self[:rule_id].nil?
    raise('name must match \'mysql_query_rule-\'<rule_id> format') if self[:name] != "mysql_query_rule-#{self[:rule_id]}"
  end

  newparam(:name, namevar: true) do
    desc 'query rule name'
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

  newproperty(:rule_id) do
    desc 'The id of the query rule.'
    newvalue(%r{\d+})
  end

  newproperty(:active) do
    desc 'Is the rule active or not.'
    defaultto 0
    newvalue(%r{[01]})
  end

  newproperty(:username) do
    desc 'Username to apply this rule to.'
    newvalue(%r{\w+})
  end

  newproperty(:schemaname) do
    desc 'Schema to apply this rule to.'
    newvalue(%r{\w+})
  end

  newproperty(:flag_in) do
    desc 'Used to chain rules. This is the id of the previous rule to apply'
    defaultto 0
    newvalue(%r{\d+})
  end

  newproperty(:flag_out) do
    desc 'Used to chain rules. This is the id of the next rule to apply'
    newvalue(%r{\d+})
  end

  newproperty(:apply) do
    desc 'Used to chain rules.'
    defaultto 0
    newvalue(%r{[01]})
  end

  newproperty(:client_addr) do
    desc 'Match traffic from a certain address.'
    newvalue(%r{\w+})
  end

  newproperty(:proxy_addr) do
    desc 'Match incoming traffic on a specific local address.'
    newvalue(%r{\w+})
  end

  newproperty(:proxy_port) do
    desc 'Match incoming traffic on a specific local port.'
    newvalue(%r{\d+})
  end

  newproperty(:digest) do
    desc 'match queries with a specific digest, as returned by stats_mysql_query_digest.digest'
    newvalue(%r{\w+})
  end

  newproperty(:match_digest) do
    desc 'regular expression that matches the query digest'
    newvalue(%r{\w+})
  end

  newproperty(:match_pattern) do
    desc 'regular expression that matches the query text'
    newvalue(%r{\w+})
  end

  newproperty(:replace_pattern) do
    desc 'this is the pattern with which to replace the matched pattern.'
    newvalue(%r{\w+})
  end

  newproperty(:negate_match_pattern) do
    desc 'if this is set to 1, only queries not matching the query text will be considered as a match. This acts as a NOT operator in front of the regular expression matching against match_pattern or match_digest.'
    defaultto 0
    newvalue(%r{[01]})
  end

  newproperty(:destination_hostgroup) do
    desc 'The hostgroup to send this query to.'
    newvalue(%r{\d+})
  end

  newproperty(:cache_ttl) do
    desc 'The amount of miliseconds to cache the result of this query.'
    newvalue(%r{\d+})
  end

  newproperty(:reconnect) do
    desc 'feature currently not in use.'
    newvalue(%r{[01]})
  end

  newproperty(:timeout) do
    desc 'The maximum amount of miliseconds in which the matched or rewritten query should be executed.'
    newvalue(%r{\d+})
  end

  newproperty(:retries) do
    desc 'the maximum number of times a query needs to be re-executed in case of detected failure during the execution of the query.'
    newvalue(%r{\d+})
  end

  newproperty(:delay) do
    desc 'number of milliseconds to delay the execution of the query.'
    newvalue(%r{\d+})
  end

  newproperty(:error_msg) do
    desc 'query will be blocked, and the specified error_msg will be returned to the client.'
    newvalue(%r{\w+})
  end

  newproperty(:log) do
    desc 'query will be logged.'
    newvalue(%r{[01]})
  end

  newproperty(:mirror_hostgroup) do
    desc 'see https://github.com/sysown/proxysql/blob/master/doc/mirroring.md.'
    newvalue(%r{\d+})
  end

  newproperty(:mirror_flag_out) do
    desc 'see https://github.com/sysown/proxysql/blob/master/doc/mirroring.md'
    newvalue(%r{\d+})
  end

  newproperty(:comment) do
    desc 'free form text field, usable for a descriptive comment of the query rule.'
    newvalue(%r{[\w+]})
  end
end
