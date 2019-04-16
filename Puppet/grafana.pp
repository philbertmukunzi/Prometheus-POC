node 'grafana' {
  class { 'apache': }             # use apache module
  apache::vhost { 'example.com':  # define vhost resource
    port    => '80',
    docroot => '/var/www/html'
  }

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
}
