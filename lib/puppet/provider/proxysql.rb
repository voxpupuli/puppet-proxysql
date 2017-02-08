class Puppet::Provider::Proxysql < Puppet::Provider
  # Without initvars commands won't work.
  initvars

  # Make sure we find mysql commands on CentOS and FreeBSD
  ENV['PATH'] = ENV['PATH'] + ':/usr/libexec:/usr/local/libexec:/usr/local/bin'

  commands mysql: 'mysql'

  # Optional defaults file
  def self.defaults_file
    if File.file?("#{Facter.value(:root_home)}/.my.cnf")
      "--defaults-extra-file=#{Facter.value(:root_home)}/.my.cnf"
    end
  end

  def defaults_file
    self.class.defaults_file
  end

  def make_sql_value(value)
    if value.nil?
      'NULL'
    elsif value.is_a? Integer
      value.to_s
    else
      "'#{value}'"
    end
  end
end
