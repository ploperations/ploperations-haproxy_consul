require 'spec_helper'

describe 'haproxy_consul::resolver' do
  let(:title) { 'https://consul.example.com:8500' }

  # Mock functions from ploperations/consul_data
  before(:each) do
    Puppet::Parser::Functions.newfunction(:'consul_data::get_service_nodes', type: :rvalue) do |_args|
      [
        { 'Address' => '10.0.0.101', 'Node' => 'consul-app-dev-1.doesnotexist' },
        { 'Address' => '10.0.0.102', 'Node' => 'consul-app-dev-2.doesnotexist' },
        { 'Address' => '10.0.0.103', 'Node' => 'consul-app-dev-3.doesnotexist' },
      ]
    end

    Puppet::Parser::Functions.newfunction(:'consul_data::get_key', type: :rvalue) do |_args|
      '8600'
    end
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it {
        is_expected.to contain_haproxy__resolver('consul')
          .with('nameservers' => {
                  'consul-app-dev-1.doesnotexist' => '10.0.0.101:8600',
                  'consul-app-dev-2.doesnotexist' => '10.0.0.102:8600',
                  'consul-app-dev-3.doesnotexist' => '10.0.0.103:8600',
                })
      }
    end
  end
end
