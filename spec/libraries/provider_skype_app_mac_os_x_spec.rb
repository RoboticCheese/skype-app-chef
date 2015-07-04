# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_skype_app_mac_os_x'

describe Chef::Provider::SkypeApp::MacOsX do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::SkypeApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe 'PATH' do
    it 'returns the app directory' do
      expected = '/Applications/Skype.app'
      expect(described_class::PATH).to eq(expected)
    end
  end

  describe '#install!' do
    it 'uses a dmg_package to install Skype' do
      p = provider
      expect(p).to receive(:dmg_package).with('Skype').and_yield
      expect(p).to receive(:source).with(described_class::URL)
      expect(p).to receive(:action).with(:install)
      p.send(:install!)
    end
  end

  describe '#remove!' do
    it 'removes all the Skype directories' do
      p = provider
      [
        described_class::PATH,
        File.expand_path('~/Library/Application Support/Skype')
      ].each do |d|
        expect(p).to receive(:directory).with(d).and_yield
        expect(p).to receive(:recursive).with(true)
        expect(p).to receive(:action).with(:delete)
      end
      p.send(:remove!)
    end
  end
end