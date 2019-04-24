#Default Configuration
node 'default' {
  #Install the prometheus node_exporter on all the machines
  include prometheus::node_exporter

  #Test file for checking the IP and some other stats
  file {'/tmp/ip':
    ensure  => "present",
    mode    => "0644",
    content => "Here is my Public IP Address: ${ipaddress_eth0}.\n",
  }
  #Install Collectd On all machines
  class { '::collectd':
    purge           => true,
    recurse         => true,
    purge_config    => true,
    minimum_version => '5.4',
  }
}

#Prometheus Configuration
node 'prometheus' {

  class { 'prometheus::server':
    version        => '2.9.1',
    alerts         => {
      'groups' => [
        {
          'name'  => 'alert.rules',
          'rules' => [
            {
              'alert'       => 'InstanceDown',
              'expr'        => 'up == 0',
              'for'         => '5m',
              'labels'      => {
                'severity' => 'page',
              },
              'annotations' => {
                'summary'     => 'Instance {{ $labels.instance }} down',
                'description' => '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes.'
              }
            },
          ],
        },
      ],
    },
    scrape_configs => [
      #The Prometheus scrapejob, It scrapes the prometheus Server on poort 9090, add multiple servers for HA or Fed
      {
       	'job_name'        => 'prometheus',
        'scrape_interval' => '10s',
        'scrape_timeout'  => '10s',
        'static_configs'  => [
          {
            'targets' => [ 'prometheus.prompoc.io:9090', ],
            'labels'  => {
              'alias' => 'Prometheus',
            }
          }
        ],
      },
      #The node scrapejob roles, scrapes all the information from the prometheus node_exporter
      {
        'job_name'        => 'node',
        'scrape_interval' => '10s',
        'scrape_timeout'  => '10s',
        'static_configs'  => [
          {
            'targets' => [ 'prometheus.prompoc.io:9100', 'grafana.prompoc.io:9100', 'tenant1.prompoc.io:9100', 'tenant2.prompoc.io:9100' ],
            'labels'  => {
              'alias' => 'Nodes',
            }
          }
        ],
      },
    ],
  }
}

#Grafana Configuration
node 'grafana' {
  class { 'grafana':
    cfg => {
      app_mode => 'production',
      server   => {
        http_port     => 3000,
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
}

#Tenant1 Configuration
node 'tenant1' {

}
