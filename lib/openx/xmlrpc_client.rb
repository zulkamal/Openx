require 'xmlrpc/client'

module OpenX

  unless defined? HTTPBroken
    # A module that captures all the possible Net::HTTP exceptions
    # from http://pastie.org/pastes/145154
    module HTTPBroken; end
    [
      Timeout::Error, Errno::EINVAL, Errno::EPIPE,
      Errno::ECONNRESET, EOFError, Net::HTTPBadResponse,
      Net::HTTPHeaderSyntaxError, Net::ProtocolError
    ].each {|m| m.send(:include, HTTPBroken) }
  end

  class XmlrpcClient
    attr_reader :client, :url

    def initialize(url)
      @url = url
      init_client!
    end

    def call(method, *args)
      @client.call(method, *convert(args))
    rescue HTTPBroken
      raise unless OpenX.configuration['retry']
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
    rescue XMLRPC::FaultException => error
      raise unless error.message =~ /Session ID.*invalid/i
      session.recreate!
      retry
    end

    protected

      def convert(args)
         [session.id] + args
      end

  end
end
