require 'spec_helper'

describe Klepto do

  describe "composed configurations" do
    before :each do
      Klepto.configure(:s3_bucket => 'pail', :file => 'spec/fixtures/config.yml') do |c|
        c.trove_server 'http://trove.example.com'
      end
    end

    it "has config from file" do
      Klepto.trove_api_key.should eq('super_secret_key')
    end

    it "has config from params" do
      Klepto.s3_bucket.should eq('pail')
    end

    it "has config from block" do
      Klepto.trove_server.should eq('http://trove.example.com')
    end
  end

  describe "#configure with parameters" do
    it "sets options" do
      Klepto.configure(:trove_api_key => 'abc')
      Klepto.trove_api_key.should eq('abc')
    end

    it "handles hash keys as strings" do
      Klepto.configure("trove_api_key" => 'def')
      Klepto.trove_api_key.should eq('def')
    end

    it "ignores undefined configuration options" do
      ->{ Klepto.configure(:undefined_option => 'abc') }.should_not raise_error
    end
  end

  describe "#configure with a yaml file" do
    it "sets options from a file with relative path" do
      Klepto.configure(:file => 'spec/fixtures/config.yml')
      Klepto.trove_api_key.should eq('super_secret_key')
    end

    it "sets options from a file with absolute path" do
      Klepto.configure(:file => "#{Klepto.root}/spec/fixtures/config.yml")
      Klepto.trove_api_key.should eq('super_secret_key')
    end

    it "sets options from a file with different environments" do
      Klepto.configure(:file => "#{Klepto.root}/spec/fixtures/config_with_environment.yml", :environment => 'exotic')
      Klepto.trove_api_key.should eq('super_secret_key')
    end
  end

  describe "#configure with a block" do
    it "sets a trove api key" do
      Klepto.configure do |c|
        c.trove_api_key 'abc'
      end

      Klepto.trove_api_key.should eq('abc')
    end

    it "sets a trove server" do
      Klepto.configure do |c|
        c.trove_server 'http://trove.example.com'
      end

      Klepto.trove_server.should eq('http://trove.example.com')
    end

    it "sets a tootsie server" do
      Klepto.configure do |c|
        c.tootsie_server 'http://tootsie.example.com'
      end

      Klepto.tootsie_server.should eq('http://tootsie.example.com')
    end

    it "sets an s3 domain" do
      Klepto.configure do |c|
        c.s3_bucket 'bucket.com'
      end

      Klepto.s3_bucket.should eq('bucket.com')
    end

    it "sets an archive" do
      Klepto.configure do |c|
        c.archive 'papaya'
      end

      Klepto.archive.should eq('papaya')
    end

    it "sets a source path" do
      Klepto.configure do |c|
        c.source_path '/path/to/images'
      end

      Klepto.source_path.should eq('/path/to/images')
    end
  end

end
