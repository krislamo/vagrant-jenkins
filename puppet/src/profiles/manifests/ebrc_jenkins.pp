# manage requirements for Jenkins server instances
# for EuPathDB
class profiles::ebrc_jenkins {

    include ::profiles::base
    include ::profiles::ebrc_java_stack
    include ::profiles::local_home
    include ::ebrc_jenkins

    Class['::profiles::ebrc_java_stack'] ->
    Class['::profiles::local_home'] ->
    Class['::ebrc_jenkins']
    
  $jenkins_instances = hiera('ebrc_jenkins::instances')
  $jenkins_instances.each |$instance, $conf| {
    $port = $conf['http_port']
    firewalld_rich_rule { "Jenkins instance ${instance}":
      ensure => present,
      zone   => 'public',
      port   => {
        'port'     => $port,
        'protocol' => 'tcp',
        },
      action => 'accept',
    }
  }

}