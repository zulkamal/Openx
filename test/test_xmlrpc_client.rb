require File.dirname(__FILE__) + '/helper'
require 'xmlrpc/client'

class XmlrpcClientTest < OpenX::TestCase

  def client
    @client ||= OpenX::XmlrpcClient.new("http://example.com/random/path")
  end

  def stub_xrc
    stub(:call => nil, :timeout= => 10)
  end

  test "initialize" do
    assert_equal "http://example.com/random/path", client.url
    assert_instance_of XMLRPC::Client, client.client
  end

  test "call forwarding" do
    client.client.expects(:call).with('ox.getAgency', 1)
    client.call('ox.getAgency', 1)
  end

  test "call rescueing" do
    a, b, c = stub_xrc, stub_xrc, stub_xrc
    ::XMLRPC::Client.stubs(:new2).returns(a, b, c)

    a.expects(:call).with('ox.getAgency', 1).once.raises(Net::HTTPBadResponse, 'Bad response')
    b.expects(:call).with('ox.getAgency', 1).once.raises(Errno::EPIPE, 'Other problem')
    client.call('ox.getAgency', 1)

    assert_not_equal  client.client, a
    assert_not_equal  client.client, b
    assert_equal      client.client, c
  end

end
