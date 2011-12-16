require 'spec_helper'

describe Klepto::Destination::Tootsie do

  before :each do
    Klepto.configure do |c|
      c.tootsie_server "tootsie_server"
      c.s3_bucket "s3.bucket.com"
    end

    Klepto::Destination::Trove.any_instance.stub(:notification_url => 'url')
  end
  let(:tootsie) { Klepto::Destination::Tootsie.new }

  it "packages parameters" do
    expected = {
      :input_url=>"file:/path/to/image.jpg",
      :versions=>[
        {"format"=>"jpeg", "target_url"=>"s3:s3.bucket.com/100/a_uid.jpg?acl=public_read", "strip_metadata"=>true, "width"=>100},
        {"format"=>"jpeg", "target_url"=>"s3:s3.bucket.com/500/a_uid.jpg?acl=public_read", "strip_metadata"=>true, "width"=>500},
        {"format"=>"jpeg", "target_url"=>"s3:s3.bucket.com/1000/a_uid.jpg?acl=public_read", "strip_metadata"=>true, "width"=>1000},
        {"format"=>"jpeg", "target_url"=>"s3:s3.bucket.com/original/a_uid.jpg?acl=public_read", "strip_metadata"=>true, "scale"=>"none"}
    ]
    }
    tootsie.params('a_uid', '/path/to/image.jpg').should eq(expected)
  end

  it "transcodes"
  it "fails to transcode"

end
