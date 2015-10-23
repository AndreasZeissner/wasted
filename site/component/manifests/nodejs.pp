class component::nodejs (
  $version    => 'stable',
){
  class { '::nodejs':
    version      => $version,
    make_install => false
  }
  contain '::nodejs'
}
