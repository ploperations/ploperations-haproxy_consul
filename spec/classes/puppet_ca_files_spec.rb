require 'spec_helper'

describe 'haproxy_consul::puppet_ca_files' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_exec('create /etc/haproxy/certs.d') }
      it { is_expected.to contain_file('/etc/haproxy/certs.d').with('ensure' => 'directory') }
      it { is_expected.to contain_file('/etc/haproxy/certs.d/puppet-crl.pem') }
      it { is_expected.to contain_file('/etc/haproxy/certs.d/puppet_ca.pem') }
    end
  end
end
