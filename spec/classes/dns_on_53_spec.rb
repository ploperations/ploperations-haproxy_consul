require 'spec_helper'

describe 'haproxy_consul::dns_on_53' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_firewall('102 forward incoming TCP port 53 to 8600') }
      it { is_expected.to contain_firewall('102 forward incoming UDP port 53 to 8600') }
      it { is_expected.to contain_firewall('102 forward outgoing TCP port 8600 to 53') }
      it { is_expected.to contain_firewall('102 forward outgoing UDP port 8600 to 53') }
    end
  end
end
