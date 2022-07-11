# Facter < 4 needs lsb-release for os.distro.codename
if $facts['os']['name'] == 'Ubuntu' and versioncmp($facts['facterversion'], '4.0.0') <= 0 {
  package { 'lsb-release':
    ensure => installed,
  }
}
