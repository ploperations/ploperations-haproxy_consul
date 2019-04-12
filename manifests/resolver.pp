# Generates a HAProxy resolver backed by Consul by querying the specified
# Consul server and getting all the nodes for the service named `consul`. The
# resolver will use port 8600 for DNS queries by default but that can be
# overridden by crating a key named `consul-dns/port` and setting its value
# to the desired port (i.e. 53).
#
# @summary Generates a HAProxy resolver backed by Consul
#
# @example
#   haproxy_consul::resolver { 'https://consul.example.com:8500': }
#
# @param consul_server
#   The full url to your Consul server including protocol and port
# @param resolver_name
#   The name of the resolver that will be referenced in the balancemember's options
#   Defaults to 'consul'
# @param resolve_retries
#   Defines the number <nb> of queries to send to resolve a server name before
#    giving up. Defaults to 3.
# @param timeout
#   Defines timeouts related to name resolution in the listening serivce's
#    configuration block. Defaults to { 'retry' => '2s' }
# @param hold
#   Defines <period> during which the last name resolution should be kept
#     based on last valid resolution status. Defaults to undef
#
# @see haproxy::resolver for more details on HAProxy-related parameters
define haproxy_consul::resolver(
  Stdlib::Httpurl $consul_server = $title,
  String[1] $resolver_name = 'consul',
  Integer $resolve_retries = 3,
  Hash $timeout = { 'retry' => '2s' },
  Optional[Hash] $hold = undef,
) {
  include haproxy

  $consul_name_servers = consul_data::get_service_nodes($consul_server, 'consul')
  $consul_dns_port = pick(consul_data::get_key($consul_server, 'consul-dns/port'), '8600')

  $nameserver_hash = $consul_name_servers.reduce( {} ) |$memo, $nameserver| {
    $memo + { "${nameserver['Node']}" => "${nameserver['Address']}:${consul_dns_port}" }
  }

  haproxy::resolver { $resolver_name:
    nameservers           => $nameserver_hash,
    resolve_retries       => $resolve_retries,
    timeout               => $timeout,
    hold                  => $hold,
    accepted_payload_size => 8192,
  }
}
