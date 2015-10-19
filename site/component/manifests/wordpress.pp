class component::wordpress (
  $path             = hiera('path', '/var/www/app_name'),
  $vhost            = hiera('vhost', 'app-name.dev'),
  $vhost_port       = 80,
  $ssl              = false,
  $mutisite         = false,
  $database         = undef,
  $php_extension    = {
                      'mysql' => {ensure  => 'present'},
                      'curl'  => {ensure  => 'present'},
                      'json'  => {ensure  => 'present'}
                      }
) {
  ## create vhost for Wordpress
  nginx::resource::vhost { "${vhost}-${vhost_port}-wordpress" :
    ensure      => present,
    server_name => [$vhost],
    www_root    => $path,
    listen_port => $vhost_port,
  }
  ## create location to direct .php to the fpm pool
  nginx::resource::location { 'wasted-php-rewrite':
    location  => '~ \.php$',
    vhost     => "${vhost}-${vhost_port}-wordpress",
    fastcgi   => '127.0.0.1:9000',
    try_files => ['$uri =404'],
    www_root  => $path,
  }

  contain '::mysql::server'
  contain '::mysql::client'
  contain '::php'

  # TODO This throws an error but works "Warning: Scope(Php::Extension[json]): php::extension is private"

  create_resources('::php::extension', $php_extension)
  create_resources('::mysql::db', $database)
  }


