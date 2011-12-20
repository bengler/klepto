module Klepto
  class Source

    attr_accessor :archive, :path
    def initialize(archive, path)
      self.archive = archive
      self.path = path
    end

    def uids
      uids = {}
      Find.find(full_path) do |file|
        next if FileTest.directory?(file)
        next if File.basename(file).start_with?(".")
        next if not FileTest.readable?(file)

        relative_path = file.sub(full_path, '')
        uids[generate_uid(relative_path)] = file
      end
      uids
    end

    def full_path
      if path[0] == '/'
        path
      else
        "#{Klepto.root}/#{path}"
      end
    end

    def generate_uid(file)
      uid = Digest::SHA1.hexdigest("We could make pasta..? #{file} #{archive}")
      "#{archive}_#{uid}"
    end

  end
end
