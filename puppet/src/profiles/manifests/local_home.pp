# manage a home that is on a local filesystem
# as opposed to NFS
class profiles::local_home {

    $local_home = hiera('local_home')

    file{ [$local_home]:
      ensure => directory,
    }
}