# Add firewall rules that let you hit Consul's DNS interface on the standard
# port (53), without running Consul as root, and while preserving access on its
# default port of 8600.
# 
# @see: https://www.consul.io/docs/guides/forwarding.html#iptables-setup
#
# @summary Forward port 53 to Consul DNS on port 8600
#
# @example
#   # applied only on Consul servers
#   include haproxy_consul::dns_on_53
class haproxy_consul::dns_on_53 {
  firewall {
    default:
      table   => 'nat',
      chain   => 'PREROUTING',
      dport   => 53,
      jump    => 'REDIRECT',
      toports => 8600,
    ;
    '102 forward incoming UDP port 53 to 8600':
      proto => 'udp',
    ;
    '102 forward incoming TCP port 53 to 8600':
      proto => 'tcp',
    ;
  }

  firewall {
    default:
      table       => 'nat',
      chain       => 'OUTPUT',
      destination => '127.0.0.1',
      dport       => 53,
      jump        => 'REDIRECT',
      toports     => 8600,
    ;
    '102 forward outgoing UDP port 8600 to 53':
      proto => 'udp',
    ;
    '102 forward outgoing TCP port 8600 to 53':
      proto => 'tcp',
    ;
  }
}
