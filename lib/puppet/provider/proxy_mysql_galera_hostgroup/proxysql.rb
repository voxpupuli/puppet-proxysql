# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'proxysql'))
Puppet::Type.type(:proxy_mysql_galera_hostgroup).provide(:proxysql, parent: Puppet::Provider::Proxysql) do
  desc 'Manage galera hostgroup for a ProxySQL instance.'
  commands mysql: 'mysql'

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  # Generates method for all properties of the property_hash
  mk_resource_methods

  def self.mysql_galera_hostgroup_properties
    select = db_fields.map { |f| "`#{f}`" }.join(',')
    begin
      hostgroups = mysql([defaults_file, '-NBe', "SELECT #{select} FROM `mysql_galera_hostgroups`"].compact).split(%r{\n})
    rescue Puppet::ExecutionFailure => e
      Puppet.debug "#mysql_galera_hostgroup_properties had an error -> #{e.inspect}"
      return {}
    end

    hostgroups.map do |hostgroup|
      hostgroup_properties = {}
      hostgroup_properties[:ensure] = :present
      hostgroup_properties[:provider] = :proxysql

      # insert each field returned by the query into the hash with the matching key
      hostgroup.split(%r{\t}).each_with_index { |field, index| hostgroup_properties[db_fields[index]] = field }

      # create :name from other hostgroup fields
      hostgroup_properties[:name] = namevar_db_fields.map { |field| hostgroup_properties[field] }.join('-')

      # Convert each integer field into a proper integer
      integer_db_fields.each { |field| hostgroup_properties[field] = hostgroup_properties[field].to_i }
      hostgroup_properties
    end
  end

  def self.instances
    mysql_galera_hostgroup_properties.map do |properties|
      new(properties)
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name] # rubocop:disable Lint/AssignmentInCondition
        resource.provider = prov
      end
    end
  end

  def create
    query_parameters = self.class.db_fields.map { |param| [param, resource[param]] }.to_h.compact

    columns = query_parameters.keys.map { |k| "`#{k}`" }.join(',')
    values = query_parameters.values.map { |value| make_sql_value(value) }.join(',')

    query = "INSERT INTO `mysql_galera_hostgroups` (#{columns}) VALUES (#{values})"
    mysql([defaults_file, '-e', query].compact)
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    @property_flush[:ensure] = :absent
  end

  def flush
    if @property_flush[:ensure] == :absent
      delete_hostgroup
      @property_flush.clear
      @property_hash.clear
      return
    end

    update_hostgroup unless @property_flush.empty?

    mysql([defaults_file, '-NBe', 'LOAD MYSQL SERVERS TO RUNTIME'].compact) if resource.load_to_runtime?
    mysql([defaults_file, '-NBe', 'SAVE MYSQL SERVERS TO DISK'].compact) if resource.save_to_disk?

    # Collect the resources again once they've been changed (that way `puppet
    # resource` will show the correct values after changes have been made).
    @property_hash = self.class.mysql_galera_hostgroup_properties.find { |hostgroup| hostgroup[:name] == resource[:name] }
  end

  # Create our own setters for all properties other than `ensure`
  resource_type.validproperties.each do |property|
    property = property.intern
    next if property == :ensure

    define_method("#{property}=") do |value|
      @property_flush[property] = value
      @property_hash[property] = value
    end
  end

  def update_hostgroup
    updates = @property_flush.map do |k, v|
      "`#{k}` = #{make_sql_value(v)}"
    end.join(',')

    query = "UPDATE mysql_galera_hostgroups SET #{updates} WHERE #{sql_where}"

    mysql([defaults_file, '-e', query].compact)
  end

  def delete_hostgroup
    query = "DELETE FROM mysql_galera_hostgroups WHERE #{sql_where}"
    mysql([defaults_file, '-e', query].compact)
  end

  def sql_where
    self.class.namevar_db_fields.map { |param| "`#{param}` = #{@resource.value(param)}" }.join(' AND ')
  end

  def self.namevar_db_fields
    %i[
      writer_hostgroup
      backup_writer_hostgroup
      reader_hostgroup
      offline_hostgroup
    ]
  end

  def self.integer_db_fields
    namevar_db_fields + %i[
      active
      max_writers
      writer_is_also_reader
      max_transactions_behind
    ]
  end

  def self.db_fields
    integer_db_fields + [:comment]
  end
end
