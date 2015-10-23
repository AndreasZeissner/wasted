class component::wordpress (
  $path             = hiera('path', '/var/www/app_name'),
  $vhost            = hiera('vhost', 'app-name.dev'),
  $vhost_port       = 80,
  $ssl              = false,
  $mutisite         = false
) {
  if $ssl {
    exec {'create_self_signed_sslcert':
      command => "openssl req -newkey rsa:2048 -nodes -keyout ${vhost}.key  -x509 -days 365 -out ${vhost}.crt -subj '/CN=${vhost}'",
      creates => [ "/etc/ssl/${vhost}.key", "/etc/${vhost}.crt", ],
      path    => ["/usr/bin", "/usr/sbin"],
      # require => Resource["${vhost}-${vhost_port}-wordpress"]
    }
  }
  ## create vhost for Wordpress
  nginx::resource::vhost { "${vhost}-${vhost_port}-wordpress" :
    ensure              => present,
    server_name         => [$vhost],
    ssl                 => $ssl,
    ssl_cert            => "/vagrant/${vhost}.cert",
    ssl_key             => "/vagrant/${vhost}.key",
    www_root            => $path,
    listen_port         => $vhost_port,
  }
  ## create location to direct .php to the fpm pool
  nginx::resource::location { 'wasted-php-rewrite':
    location  => '~ \.php$',
    vhost     => "${vhost}-${vhost_port}-wordpress",
    ssl       => $ssl,
    fastcgi   => '127.0.0.1:9000',
    try_files => ['$uri =404'],
    www_root  => $path,
  }
}


