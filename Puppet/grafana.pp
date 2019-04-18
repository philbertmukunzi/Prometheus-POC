mod 'puppet-collectd', '10.1.0'


node 'grafana' {
  class { 'grafana':
    cfg => {
      app_mode => 'production',
      server   => {
        http_port     => 8080,
      },
      database => {
        type          => 'sqlite3',
        host          => '127.0.0.1:3306',
        name          => 'grafana',
        user          => 'root',
        password      => '',
      },
      users    => {
        allow_sign_up => false,
      },
    },
  }

  class { '::collectd':
    purge           => true,
    recurse         => true,
    purge_config    => true,
    minimum_version => '5.4',
  }

  class { 'prometheus::node_exporter':
    version            => '0.17.0',
    collectors_disable => ['loadavg', 'mdadm'],
    extra_options      => '--collector.ntp.server ntp1.orange.intra',
  }
}
