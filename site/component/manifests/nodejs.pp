class component::nodejs (
  $version      = 'stable',
  $make_install = false
){
  if !($version == 'stable') {
    $make_install = true
  }
  class { '::nodejs':
    version      => $version,
    make_install => $make_install
  }
  contain '::nodejs'
}
