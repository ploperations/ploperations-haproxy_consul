
# haproxy_consul

![](https://img.shields.io/puppetforge/pdk-version/ploperations/haproxy_consul.svg?style=popout)
![](https://img.shields.io/puppetforge/v/ploperations/haproxy_consul.svg?style=popout)
![](https://img.shields.io/puppetforge/dt/ploperations/haproxy_consul.svg?style=popout)
[![Build Status](https://travis-ci.org/ploperations/ploperations-haproxy_consul.svg?branch=master)](https://travis-ci.org/ploperations/ploperations-haproxy_consul)

## Description

This module provides helpers for using Consul with HAProxy. In particular, it provides:
- a simplified way to make your Consul server listen on port 53 via the `dns_on_53` class
- a reusable block of code for setting up connection validation between HAProxy and somthing using your Puppet CA via the `puppet_ca_files` class
- a defined type named `resolver` that sets up a resolver in HAProxy that points at your Consul cluster
- a defined type named `server_tempalte` that drastically reduces the work of creating the resources needed to front services registered in Consul

## Requirements and Impact

This module will modify your HAProxy configs and can add firewall rules to your Consul server. A working Consul cluster is required also (a single node is fine).

## Usage

See [REFERENCE.md](REFERENCE.md) for examples of how to use the helpers provided by this module.

## Reference

This module is documented via
`pdk bundle exec puppet strings generate --format markdown`.
Please see [REFERENCE.md](REFERENCE.md) for more info.

## Changelog

[CHANGELOG.md](CHANGELOG.md) is generated prior to each release via
`pdk bundle exec rake changelog`. This proecss relies on labels that are applied
to each pull request.

## Limitations

This module assumes you are running HAProxy on *nix.

## Contributing

Pull requests are welcome!
