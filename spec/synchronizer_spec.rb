require 'spec_helper'

describe Klepto::Synchronizer do
  let(:sync) { Klepto::Synchronizer.new }
  let(:options) do
    Klepto.configuration_options.inject({}) {|options, o| options[o] = 'irrelevant'; options}
  end

  before :each do
    Klepto.configure(options) do |c|
      c.archive 'hello'
      c.source_path 'spec/fixtures/images/directory'
    end
  end

  it "has a delete mode" do
    sync.delete_mode!
    sync.delete?.should be_true
  end

  it "does not delete by default" do
    sync.delete?.should be_false
  end

  describe "diff" do
    let(:uid1) { 'hello_9441f3bc13a906134691ac7489e8d48308433d3a' }
    let(:uid2) { 'hello_805d4ec0492a8aebcbf062432e76f456ed175875' }

    before :each do
      destination = stub(:uids => [uid1, 'should_be_deleted'])
      sync.stub(:destination => destination)
    end

    it "finds the uids to be deleted" do
      sync.uids_for_deletion.should eq(['should_be_deleted'])
    end

    it "finds the uids to be uploaded" do
      sync.uids_for_upload.keys.should eq([uid2])
    end
  end

  Klepto.configuration_options.each do |option|
    it "cannot be initialized without #{option.inspect}" do
      Klepto.configure(options.merge(option => nil))
      ->{ Klepto::Synchronizer.new }.should raise_error(Klepto::MissingConfigurationOption)
    end
  end
end
