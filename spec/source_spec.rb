require 'spec_helper'

describe Klepto::Source do
  let(:source) { Klepto::Source.new('hello', 'spec/fixtures/images') }

  it "keeps full paths unchanged" do
    source.path = '/the/path'
    source.full_path.should eq('/the/path')
  end

  it "resolves relative paths" do
    Klepto.stub(:root => '/path/to/project')
    source.full_path.should eq('/path/to/project/spec/fixtures/images')
  end

  it "generates a uid" do
    source.generate_uid("./my_image.jpg").should eq("hello_e31bfd952e3f424a23b6ee213c7e69ac70e968d8")
  end

  describe "determining uids for import" do
    it "finds images in a directory" do
      source.path = 'spec/fixtures/images/directory'
      uids = {
        'hello_9441f3bc13a906134691ac7489e8d48308433d3a' => "#{source.full_path}/picture.jpg",
        'hello_805d4ec0492a8aebcbf062432e76f456ed175875' => "#{source.full_path}/picture2.jpg"
      }
      source.uids.should eq(uids)
    end

    it "finds images in subdirectories" do
      source.path = 'spec/fixtures/images/has_subdirectory'
      uids = {
        'hello_9441f3bc13a906134691ac7489e8d48308433d3a' => "#{source.full_path}/picture.jpg",
        'hello_74e23d7f6b1f07673f4f5d9b5b200430921e161e' => "#{source.full_path}/subdirectory/picture2.jpg"
      }
      source.uids.should eq(uids)
    end

    it "includes files with the same name but with different paths" do
      source.path = 'spec/fixtures/images/has_duplicates'
      uids = {
        'hello_9441f3bc13a906134691ac7489e8d48308433d3a' => "#{source.full_path}/picture.jpg",
        'hello_77477d24f1fd1d923129bcf13b3b1b6ef0437794' => "#{source.full_path}/subdirectory/picture.jpg"
      }
      source.uids.should eq(uids)
    end
  end

end
