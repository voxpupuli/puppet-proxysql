require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'proxysql')
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib', '--version', '4.11.0'), { :acceptable_exit_codes => [0,1] }

      lsb_dcn = fact_on(host, 'lsbdistcodename')
      commands_Debian = <<EOF
if [ ! -e /etc/apt/sources.list.d/debs.list ]
then
  echo deb http://debs.ugent.be/debian #{lsb_dcn} main >  /etc/apt/sources.list.d/debs.list
  apt-get update
  apt-get install --allow-unauthenticated ugent-keyring
  apt-get update
fi
EOF
      if fact_on(host, 'osfamily') == 'Debian'
        on host, commands_Debian
      elsif fact_on(host, 'osfamily') == 'RedHat'
        # fixme
      end

      # uncomment the section below to add needed git repositories
      # replace the module rbldnsd with the module(s) you need

#      on host, puppet('resource','package', 'git', 'ensure=present'), { :acceptable_exit_codes => [0,1] }
#      git_repos = [
#        { :mod => 'rbldnsd', :repo => 'https://github.com/rgevaert/puppet-rbldnsd.git', :ref => '1.0.0' },
#      ]
#      git_repos.each do |g|
#        step "Installing puppet module \'#{g[:repo]}\' from git on Master"
#        shell("[ -d /etc/puppetlabs/code/environments/production/modules/#{g[:mod]} ] || git clone #{g[:repo]} /etc/puppetlabs/code/environments/production/modules/#{g[:mod]}")
#        if g[:ref]
#          shell("cd /etc/puppetlabs/code/environments/production/modules/#{g[:mod]}; git checkout #{g[:ref]}")
#        end
#      end

    end
  end
end
