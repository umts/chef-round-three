require 'spec_helper'

describe 'round-three::application' do
  describe command('which ruby') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(%r{/usr/local/}) }
  end

  describe command('ruby --version') do
    its(:stdout) { should match(/2\.2\./) }
  end
end
