# @summary It sets variables according to platform.
#
# @api private
class proxysql::params {
  $datadir = '/var/lib/proxysql'

  case $facts['os']['family'] {
    'Debian': {
      $package_provider = 'dpkg'
      $package_dependencies = []

      if versioncmp(fact('os.release.major'), '18.04') >= 0 {
        # The 2.0.x systemd service file in ubuntu 18.04 has `ReadWritePaths=/var/lib/proxysql /var/run/proxysql`.
        # This limits where we can write sockets.
        $_listen_socket = "${datadir}/proxysql.sock"
        $_admin_listen_socket = "${datadir}/proxysql_admin.sock"
      }

      $repo14             = {
        comment  => 'ProxySQL 1.4.x APT repository',
        location => "http://repo.proxysql.com/ProxySQL/proxysql-1.4.x/${facts['os']['distro']['codename']}/",
        release  => './',
        repos    => '',
        key      => {
          'id'     => '1448BF693CA600C799EB935804A562FB79953B49',
          'server' => 'keyserver.ubuntu.com',
        },
      }
      $repo20             = {
        comment  => 'ProxySQL 2.0.x APT repository',
        location => "http://repo.proxysql.com/ProxySQL/proxysql-2.0.x/${facts['os']['distro']['codename']}/",
        release  => './',
        repos    => '',
        key      => {
          'id'     => '1448BF693CA600C799EB935804A562FB79953B49',
          'server' => 'keyserver.ubuntu.com',
        },
      }
      $repo21             = {
        comment  => 'ProxySQL 2.1.x APT repository',
        location => "http://repo.proxysql.com/ProxySQL/proxysql-2.1.x/${facts['os']['distro']['codename']}/",
        release  => './',
        repos    => '',
        key      => {
          'id'     => '1448BF693CA600C799EB935804A562FB79953B49',
          'server' => 'keyserver.ubuntu.com',
        },
      }
      $repo22             = {
        comment  => 'ProxySQL 2.2.x APT repository',
        location => "http://repo.proxysql.com/ProxySQL/proxysql-2.2.x/${facts['os']['distro']['codename']}/",
        release  => './',
        repos    => '',
        key      => {
          'id'     => '1448BF693CA600C799EB935804A562FB79953B49',
          'server' => 'keyserver.ubuntu.com',
        },
      }
      $repo23             = {
        comment  => 'ProxySQL 2.3.x APT repository',
        location => "http://repo.proxysql.com/ProxySQL/proxysql-2.3.x/${facts['os']['distro']['codename']}/",
        release  => './',
        repos    => '',
        key      => {
          'id'     => '1448BF693CA600C799EB935804A562FB79953B49',
          'server' => 'keyserver.ubuntu.com',
        },
      }
      $repo24             = {
        comment  => 'ProxySQL 2.4.x APT repository',
        location => "http://repo.proxysql.com/ProxySQL/proxysql-2.4.x/${facts['os']['distro']['codename']}/",
        release  => './',
        repos    => '',
        key      => {
          'id'     => '1448BF693CA600C799EB935804A562FB79953B49',
          'server' => 'keyserver.ubuntu.com',
        },
      }
      $repo25             = {
        comment  => 'ProxySQL 2.5.x APT repository',
        location => "http://repo.proxysql.com/ProxySQL/proxysql-2.5.x/${facts['os']['distro']['codename']}/",
        release  => './',
        repos    => '',
        key      => {
          'id'     => '1448BF693CA600C799EB935804A562FB79953B49',
          'server' => 'keyserver.ubuntu.com',
        },
      }
    }
    'RedHat': {
      $package_provider = 'rpm'
      $package_dependencies = ['perl-DBI', 'perl-DBD-mysql']
      $repo_os_major_version = $facts['os']['release']['major'] ? {
        '2016'  => '6',
        default => $facts['os']['release']['major'],
      }
      $repo14             = {
        name     => 'proxysql_1_4',
        descr    => 'ProxySQL 1.4.x YUM repository',
        baseurl  => "http://repo.proxysql.com/ProxySQL/proxysql-1.4.x/centos/${repo_os_major_version}",
        enabled  => true,
        gpgcheck => true,
        gpgkey   => 'http://repo.proxysql.com/ProxySQL/repo_pub_key',
      }
      $repo20             = {
        name     => 'proxysql_2_0',
        descr    => 'ProxySQL 2.0.x YUM repository',
        baseurl  => "http://repo.proxysql.com/ProxySQL/proxysql-2.0.x/centos/${repo_os_major_version}",
        enabled  => true,
        gpgcheck => true,
        gpgkey   => 'http://repo.proxysql.com/ProxySQL/repo_pub_key',
      }
      $repo21             = {
        name     => 'proxysql_2_1',
        descr    => 'ProxySQL 2.1.x YUM repository',
        baseurl  => "http://repo.proxysql.com/ProxySQL/proxysql-2.1.x/centos/${repo_os_major_version}",
        enabled  => true,
        gpgcheck => true,
        gpgkey   => 'http://repo.proxysql.com/ProxySQL/repo_pub_key',
      }
      $repo22             = {
        name     => 'proxysql_2_2',
        descr    => 'ProxySQL 2.2.x YUM repository',
        baseurl  => "http://repo.proxysql.com/ProxySQL/proxysql-2.2.x/centos/${repo_os_major_version}",
        enabled  => true,
        gpgcheck => true,
        gpgkey   => 'http://repo.proxysql.com/ProxySQL/repo_pub_key',
      }
      $repo23             = {
        name     => 'proxysql_2_3',
        descr    => 'ProxySQL 2.3.x YUM repository',
        baseurl  => "http://repo.proxysql.com/ProxySQL/proxysql-2.3.x/centos/${repo_os_major_version}",
        enabled  => true,
        gpgcheck => true,
        gpgkey   => 'http://repo.proxysql.com/ProxySQL/repo_pub_key',
      }
      $repo24             = {
        name     => 'proxysql_2_4',
        descr    => 'ProxySQL 2.4.x YUM repository',
        baseurl  => "http://repo.proxysql.com/ProxySQL/proxysql-2.4.x/centos/${repo_os_major_version}",
        enabled  => true,
        gpgcheck => true,
        gpgkey   => 'http://repo.proxysql.com/ProxySQL/repo_pub_key',
      }
      $repo25             = {
        name     => 'proxysql_2_5',
        descr    => 'ProxySQL 2.5.x YUM repository',
        baseurl  => "http://repo.proxysql.com/ProxySQL/proxysql-2.5.x/centos/${repo_os_major_version}",
        enabled  => true,
        gpgcheck => true,
        gpgkey   => 'http://repo.proxysql.com/ProxySQL/repo_pub_key',
      }
    }
    default: {
      fail("osfamily ${facts['os']['family']} is not supported")
    }
  }

  if fact('proxysql_version') {
    $short_proxysql_version_fact = regsubst(fact('proxysql_version'),'^(\\d+\\.\\d+\\.\\d+)','\\1')
  } else {
    $short_proxysql_version_fact = undef
  }
  $version = pick($short_proxysql_version_fact,'2.0.7')

  $listen_socket = pick(getvar('_listen_socket'),'/tmp/proxysql.sock')
  $admin_listen_socket = pick(getvar('_admin_listen_socket'),'/tmp/proxysql_admin.sock')
}
