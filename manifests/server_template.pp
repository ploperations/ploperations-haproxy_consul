# Creating both the `haproxy::listen` and `haproxy::balancermember` for each
# service you wish to use with HAProxy's 'server-template' requires a lot of
# redundant code and, if you are using multi-resource declarations, can put the
# two components way away from each other in your manifest. This simplifies the
# process by collecting all the information that differes from service to
# service and then creates the required haproxy resources.
#
# @summary Creates both a HAProxy listen and balancemenber resource
#
# @example
#   include haproxy_consul::puppet_ca_files
#
#   $_consul_domain = 'consul.example.com'
#   $_haproxy_cert_dir = lookup('haproxy_consul::puppet_ca_files::haproxy_cert_dir')
#   $_puppet_ca_file  = "${_haproxy_cert_dir}/${lookup('haproxy_consul::puppet_ca_files::puppet_ca_file_name')}"
#   $_puppet_crl_file = "${_haproxy_cert_dir}/${lookup('haproxy_consul::puppet_ca_files::puppet_crl_file_name')}"
#
#   haproxy_consul::server_template {
#     default:
#       consul_domain => $_consul_domain,
#       amount        => '1',
#       require       => Class['Haproxy_consul::Puppet_ca_files'],
#     ;
#     'pe-console-https':
#       ports                  => '443',
#       listen_options         => {
#         'balance' => 'roundrobin',
#         'option'  => [
#           'ssl-hello-chk',
#         ],
#       },
#       balancermember_options => [
#         'resolvers consul',
#         'resolve-prefer ipv4',
#         'check',
#       ],
#     ;
#     'pe-compiler-puppet-agent':
#       ports                  => '8140',
#       listen_options         => {
#         'option httpchk' => 'get /status/v1/simple/master',
#       },
#       balancermember_options => [
#         'resolvers consul',
#         'resolve-prefer ipv4',
#         'check check-ssl',
#         'port 8140',
#         'verify required',
#         "ca-file ${_puppet_ca_file}",
#         "crl-file ${_puppet_crl_file}",
#       ],
#       amount                 => '1-8',
#     ;
#   }
#
# @param ports
#   The port or ports the service listens on
#   Accepts either a single comma-separated string or an array of strings which
#   may be ports or hyphenated port ranges.
# @param amount
#   Initializes <num> servers with 1 up to <num> as server name suffixes.
#   A range of numbers <num_low>-<num_high> may also be used to use
#   <num_low> up to <num_high> as server name suffixes.
# @param consul_domain
#   The fqdn used by services registered in consul
# @param ipaddress
#   The address to lsten on. Defaults to '*'
# @param listen_options
#   An optional hash of options for the listening service
# @param balancermember_options
#   An optional hash of options for the backend balancemembers
define haproxy_consul::server_template (
  Variant[String[1], Array[String[1]]] $ports,
  String[1]                            $amount,
  Stdlib::Fqdn                         $consul_domain,
  String[1]                            $ipaddress              = '*',
  Optional[Hash]                       $listen_options         = undef,
  Optional[Array[String[1]]]           $balancermember_options = undef,
) {
  include haproxy

  haproxy::listen { $title:
    collect_exported => false,
    ipaddress        => $ipaddress,
    ports            => $ports,
    options          => $listen_options,
  }

  haproxy::balancermember { $title:
    listening_service => $title,
    type              => 'server-template',
    ports             => $ports,
    prefix            => $title,
    amount            => $amount,
    fqdn              => "_${title}._tcp.service.${consul_domain}",
    options           => $balancermember_options,
  }
}
