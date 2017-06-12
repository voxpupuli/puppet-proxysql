require File.expand_path(File.join(File.dirname(__FILE__), '..', 'proxysql'))
Puppet::Type.type(:proxy_global_variable).provide(:proxysql, parent: Puppet::Provider::Proxysql) do
  desc 'Manage global variables for a ProxySQL instance.'
  commands mysql: 'mysql'

  # Build a property_hash containing all the discovered information about MySQL
  # servers.
  def self.instances
    instances = []
    data = mysql([defaults_file, '-NBe', 'SHOW GLOBAL VARIABLES']).split(%r{\n})
    data.each do |line|
      var, val = line.split(%r{\t})

      val = "'#{val}'" if val.is_a?(TrueClass) || val.is_a?(FalseClass)

      instances << new(name: var, value: val)
    end
    instances
  end

  def self.prefetch(resources)
    variables = instances
    resources.keys.each do |name|
      provider = variables.find { |var| var.name == name }
      resources[name].provider = provider if provider
    end
  end

  def flush
    name = @resource[:name]
    prefix, _var = name.split('-')
    @property_hash.clear

    load_to_runtime = @resource[:load_to_runtime]
    save_to_disk = @resource[:save_to_disk]
    if prefix == 'admin'
      mysql([defaults_file, '-NBe', 'LOAD ADMIN VARIABLES TO RUNTIME'].compact) if load_to_runtime == :true
      mysql([defaults_file, '-NBe', 'SAVE ADMIN VARIABLES TO DISK'].compact) if save_to_disk == :true
    else
      mysql([defaults_file, '-NBe', 'LOAD MYSQL VARIABLES TO RUNTIME'].compact) if load_to_runtime == :true
      mysql([defaults_file, '-NBe', 'SAVE MYSQL VARIABLES TO DISK'].compact) if save_to_disk == :true
    end
  end

  # Generates method for all properties of the property_hash
  mk_resource_methods

  def value=(val)
    name = @resource[:name]
    mysql([defaults_file, '-e', "SET #{name} = '#{val}'"].compact)

    @property_hash.clear
    true
  end
end
