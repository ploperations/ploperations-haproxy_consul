require 'spec_helper'

describe 'haproxy_consul::server_template' do
  let(:title) { 'pe-console-https' }

  let(:params) do
    {
      'consul_domain'          => 'consul.example.com',
      'amount'                 => '1',
      'ports'                  => '443',
      'listen_options'         => {
        'balance' => 'roundrobin',
        'option'  => [
          'ssl-hello-chk',
        ],
      },
      'balancermember_options' => [
        'resolvers consul',
        'resolve-prefer ipv4',
        'check',
      ],
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_haproxy__listen('pe-console-https').with('ports' => '443') }
      it { is_expected.to contain_haproxy__balancermember('pe-console-https').with('amount' => '1') }
    end
  end
end
