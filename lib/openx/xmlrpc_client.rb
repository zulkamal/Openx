require 'xmlrpc/client'

module OpenX

  class XmlrpcClient
    EXCEPTION_CLASSES = [
      ::Timeout::Error,
      ::Errno::EINVAL,
      ::Errno::EPIPE,
      ::Errno::ECONNRESET,
      ::EOFError,
      ::Net::HTTPBadResponse,
      ::Net::HTTPHeaderSyntaxError,
      ::Net::ProtocolError
    ].freeze

    attr_reader :client, :url

    def initialize(url)
      @url     = url
      @retries = 0
      init_client!
    end

    def call(method, *args)
      @client.call(method, *(convert(args)))
    rescue *EXCEPTION_CLASSES => e
      cycle = (cycle || 0) + 1
      raise(e) if cycle > 10 || OpenX.configuration['retry'] == false
      init_client!
      retry
    end

    protected

      def convert(args)
        args
      end

    private

      def init_client!
        @client = XMLRPC::Client.new2(url)
        @client.timeout = OpenX.configuration['timeout']
      end

  end


  class XmlrpcSessionClient < XmlrpcClient

    attr_reader :session

    def initialize(session)
      @session = session
      super(session.url)
    end

    def call(method, *args)
      super
    rescue XMLRPC::FaultException => e
      cycle = (cycle || 0) + 1
      raise(e) if cycle > 10 || e.message !~ /Session ID.*invalid/i
      session.recreate!
      retry
    end

    protected

      def convert(args)
         [session.id] + args
      end

  end
end
