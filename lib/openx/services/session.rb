module OpenX
  module Services
    class Session
      attr_accessor :id, :uri, :user, :password

      def initialize(url)
        @uri    = URI.parse(url)
        @client = XmlrpcClient.new(self.url)
        @id     = nil
      end

      def url
        uri.to_s
      end

      def host
        url.sub(/#{Regexp.escape(uri.path)}$/, '')
      end

      def remote
        @remote ||= XmlrpcSessionClient.new(self)
      end

      def create(user, password)
        self.user     = user
        self.password = password
        self.id       = @client.call('ox.logon', user, password)
        self
      end

      def recreate!
        raise "Unable to refresh Session" unless user && password
        self.id = @client.call('ox.logon', user, password)
        self
      end

      def destroy
        @client.call('ox.logoff', id)
        self.id = nil
        self
      end
    end
  end
end
