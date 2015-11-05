require 'serverspec'
set :backend, :exec

describe package 'docker-engine' do
  it { should be_installed }
end

describe command 'docker -v' do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Docker version 1.9.0/) }
end

describe command 'grep "insecure-registry" /etc/default/docker' do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/registry.insecure.com:5000/) }
end
