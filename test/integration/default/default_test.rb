# InSpec test for hab_haproxy Chef Habitat package

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

control 'service checks' do
  impact 0.7
  title 'Check for creation of service.'
  # http://inspec.io/docs/reference/resources/systemd_service/
  describe.one do
    describe systemd_service('hab-sup') do
      it { should be_installed }
      it { should be_enabled }
    end
    describe service('hab-sup') do
      it { should be_installed }
      it { should be_enabled }
    end
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
