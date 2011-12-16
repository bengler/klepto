module Klepto
  class Destination
    class Tootsie

      attr_accessor :server, :s3, :sizes
      def initialize
        self.server = Klepto.tootsie_server
        self.s3 = Klepto.s3_bucket
        self.sizes = [100, 500, 1000, "original"]
      end

      def transcode(uid, path, options = {})
        options = {
          :type => 'image',
          :params => params(uid, path),
          :notification_url => options[:notification_url]
        }

        client = HTTPClient.new
        response = client.post("#{server}/job", options.to_json)
        case response.status_code
        when 200..299
          return true
        else
          puts "HTTP request failed with error #{response.code}"
          return false
        end
      end

      def params(uid, path)
        params = {}
        params[:input_url] = "file:#{path}"
        params[:versions] = []
        sizes.each do |size|
          params[:versions] << version_options(uid, size)
        end
        params
      end

      def version_options(uid, size)
        options = {
          "format" => "jpeg",
          "target_url" => "s3:#{s3}/#{size}/#{uid}.jpg?acl=public_read",
          "strip_metadata" => true
        }
        if size == "original"
          options["scale"] = "none"
        else
          options["width"] = size
        end
        options
      end
    end

  end
end
