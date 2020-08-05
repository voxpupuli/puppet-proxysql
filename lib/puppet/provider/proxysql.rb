class Puppet::Provider::Proxysql < Puppet::Provider
  # Without initvars commands won't work.
  initvars

  # Make sure we find mysql commands on CentOS and FreeBSD
  ENV['PATH'] = ENV['PATH'] + ':/usr/libexec:/usr/local/libexec:/usr/local/bin'

  commands mysql: 'mysql'

  # Optional defaults file
  def self.defaults_file
    "--defaults-extra-file=#{Facter.value(:root_home)}/.my.cnf" if File.file?("#{Facter.value(:root_home)}/.my.cnf")
  end

  def defaults_file
    self.class.defaults_file
  end

  # Check if we're running a version of ProxySQL that supports GTID tracking
  def self.has_gtid_tracking?
    Facter.value(:proxysql_version) && Puppet::Util::Package.versioncmp(Facter.value(:proxysql_version), '2.0.1') >= 0
  end

  def has_gtid_tracking?
    self.class.has_gtid_tracking?
  end

  def make_sql_value(value)
    if value.nil?
      'NULL'
    elsif value == 'NULL'
      'NULL'
    elsif value.is_a? Integer
      value.to_s
    else
      "'#{value}'"
    end
  end
end
