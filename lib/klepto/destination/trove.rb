module Klepto
  class Destination
    class Trove

      attr_accessor :archive, :server, :api_key
      def initialize
        self.archive = Klepto.archive
        self.server = "#{Klepto.trove_server}/api/trove/v1"
        self.api_key = Klepto.trove_api_key
      end

      def uids
        @uids ||= JSON.parse(issue_request(uids_endpoint, :get))
      end

      def delete(uids)
        issue_request(delete_uids_endpoint, :post, {:uids => uids}.to_json)
      end

      def uids_endpoint
        "#{server}/archives/#{archive}/uids"
      end

      def delete_uids_endpoint
        "#{server}/delete_with_sync/#{api_key}"
      end

      def notification_url(uid)
        "#{server}/create_with_sync/#{archive}/#{uid}/#{api_key}"
      end

      def issue_request(url, method, body = "")
        client = HTTPClient.new
        response = client.get(url) if method == :get
        response = client.post(url, body) if method == :post
        case response.status_code
        when 200..299
          return response.body
        else
          raise "#{method.to_s} #{url} failed with error #{response.code}"
        end
      end

    end
  end
end
