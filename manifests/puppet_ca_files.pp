# Setup connection validation via Puppet CA by copying the Puppet CA and CRL
# into a place that HAProxy can access to us for connection validation
#
# @summary Setup connection validation via Puppet CA
#
# @example
#   include haproxy_consul::puppet_ca_files
#
# @param haproxy_cert_dir
#   The directory that will hold teh CA and CRL files
#   Defaults to '/etc/haproxy/certs.d'
# @param puppet_ca_file_name
#   The name to use for the CA file
#   Defaults to 'puppet_ca.pem'
# @param puppet_crl_file_name
#   The name to use for the CRL
#   Defaults to 'puppet-crl.pem'
class haproxy_consul::puppet_ca_files (
  Stdlib::Unixpath $haproxy_cert_dir,
  String[1] $puppet_ca_file_name,
  String[1] $puppet_crl_file_name,
) {
  include haproxy

  $_puppet_ca_file  = "${haproxy_cert_dir}/${puppet_ca_file_name}"
  $_puppet_crl_file = "${haproxy_cert_dir}/${puppet_crl_file_name}"

  exec { "create ${haproxy_cert_dir}":
    path    => '/bin:/usr/bin',
    command => "mkdir -p ${haproxy_cert_dir}",
    creates => $haproxy_cert_dir,
  }

  file {
    default:
      ensure  => file,
      mode    => '0644',
      require => Exec["create ${haproxy_cert_dir}"],
      notify  => Haproxy::Service['haproxy'],
    ;
    $haproxy_cert_dir:
      ensure => directory,
      mode   => '0755',
    ;
    $_puppet_ca_file:
      source => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
    ;
    $_puppet_crl_file:
      source => '/etc/puppetlabs/puppet/ssl/crl.pem'
    ;
  }
}
