# == Class proxysql::cluster
#
# This class is called from proxysql for cluster config.
#
class proxysql::cluster {

  if $proxysql::cluster_name != '' {
    resources { 'proxy_cluster':
      purge => true,
    }
    $query = "resources[parameters] {type = 'Class' and title = 'Proxysql' and parameters.cluster_name = '${proxysql::cluster_name}'}"
    $nodes = puppetdb_query($query).map | $hash | { $hash['parameters']['node_name'] }

    $nodes.each |String $node| {
      proxy_cluster { $node:
        hostname => "${split($node, ':')[0]}",
        port     => split($node, ':')[1]
      }
    }
  }
}
