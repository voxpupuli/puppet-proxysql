# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  install_module_from_forge_on(host, 'puppet/selinux', '>= 0')
end
