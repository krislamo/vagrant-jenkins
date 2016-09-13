

class profiles::base {

  package { [
      'git',
    ]:
    ensure => 'installed',
  }

}