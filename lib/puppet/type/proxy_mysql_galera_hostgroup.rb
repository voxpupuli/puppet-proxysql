require 'puppet/parameter/boolean'

Puppet::Type.newtype(:proxy_mysql_galera_hostgroup) do
  @doc = 'Manage a ProxySQL mysql_galera_hostgroup.'

  autorequire(:file) { '/root/.my.cnf' }
  autorequire(:class) { 'mysql::client' }
  autorequire(:service) { 'proxysql' }

  def self.title_patterns
    [
      [
        %r{^((\d+)-(\d+)-(\d+)-(\d+))$},
        [
          [:name],
          [:writer_hostgroup],
          [:backup_writer_hostgroup],
          [:reader_hostgroup],
          [:offline_hostgroup]
        ]
      ],
      [
        %r{^(.*)$},
        [
          [:name]
        ]
      ]
    ]
  end

  ensurable do
    defaultvalues
    defaultto :present
  end

  validate do
    [
      :writer_hostgroup,
      :backup_writer_hostgroup,
      :reader_hostgroup,
      :offline_hostgroup
    ].each do |namevar|
      raise Puppet::Error, "proxy_mysql_galera_hostgroup: #{namevar} is required or use `<writer_hostgroup>-<backup_writer_hostgroup>-<reader_hostgroup>-<offline_hostgroup>` style resource title" unless self[namevar]
    end
  end

  newparam(:name, namevar: true) do
    desc 'name to describe the hostgroup config'
    munge do |_discard|
      [
        @resource.original_parameters[:writer_hostgroup],
        @resource.original_parameters[:backup_writer_hostgroup],
        @resource.original_parameters[:reader_hostgroup],
        @resource.original_parameters[:offline_hostgroup]
      ].join('-')
    end
  end

  newparam(:writer_hostgroup, namevar: true) do
    desc 'Writer hostgroup.'
    munge(&:to_i)
  end

  newparam(:backup_writer_hostgroup, namevar: true) do
    desc 'Backup Writer hostgroup.'
    munge(&:to_i)
  end

  newparam(:reader_hostgroup, namevar: true) do
    desc 'Reader hostgroup.'
    munge(&:to_i)
  end

  newparam(:offline_hostgroup, namevar: true) do
    desc 'Offline hostgroup.'
    munge(&:to_i)
  end

  newparam(:load_to_runtime, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'Load this entry to the active runtime.'
    defaultto true
  end

  newparam(:save_to_disk, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'Perist this entry to the disk.'
    defaultto true
  end

  newproperty(:active) do
    desc 'active'
    munge(&:to_i)
  end

  newproperty(:max_writers) do
    desc 'Maximum Writers'
    munge(&:to_i)
  end

  newproperty(:writer_is_also_reader) do
    desc 'A writer is also used for reading'
    munge(&:to_i)
  end

  newproperty(:max_transactions_behind) do
    desc 'Maximum Transaction Galera Node out-of-sync'
    munge(&:to_i)
  end

  newproperty(:comment) do
    desc 'text field can be used to store any arbitrary data.'
    newvalue(%r{[\w+]})
  end
end
