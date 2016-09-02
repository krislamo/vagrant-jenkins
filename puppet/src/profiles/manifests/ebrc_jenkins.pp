# manage requirements for Jenkins server instances
# for EuPathDB
class profiles::ebrc_jenkins {

    include ::profiles::ebrc_java_stack
    include ::profiles::local_home
    include ::ebrc_jenkins

    Class['::profiles::ebrc_java_stack'] ->
    Class['::profiles::local_home'] ->
    Class['::ebrc_jenkins']
    
    firewalld::custom_service{ 'Allow jenkins in public zone':
      short  => 'jenkins',
      port   => [
        {
          'port'     => 9191,
          'protocol' => 'tcp'
        },
        {
          'port'     => 9181,
          'protocol' => 'tcp'
        },
        {
          'port'     => 9130,
          'protocol' => 'tcp'
        },
        {
          'port'     => 9120,
          'protocol' => 'tcp'
        },
      ],
      before => Firewalld_service['Allow jenkins in public zone'],
    }

    firewalld_service {'Allow jenkins in public zone':
        ensure  => 'present',
        zone    => 'public',
        service => 'jenkins',
    }



}