# InSpec test for hab_haproxy Chef Habitat package

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

control 'service_checks' do
  impact 0.7
  title 'Check for running haproxy service'
  describe command('hab svc status') do
    its('exit_status') { should cmp 0 }
    its('stdout') { should match /haproxy.*up.*up/ }
  end
end

control 'haproxy' do
  impact 0.7
  title 'haproxy components'
  # default haproxy front-end
  describe port('11080') do
    it { should be_listening }
  end
  # haproxy status page
  describe port('19080') do
    it { should be_listening }
  end
end
