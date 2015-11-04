require_relative '../../../kitchen/data/spec_helper'

package 'docker' do
  it { should be_installed }
end

command 'docker -v' do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/docker version 1.9.0/) }
end

command 'grep "insecure-registry" /etc/default/docker' do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/registry.insecure.com:5000/) }
end
