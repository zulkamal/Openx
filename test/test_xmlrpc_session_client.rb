require File.dirname(__FILE__) + '/helper'
require 'xmlrpc/client'

class XmlrpcSessionClientTest < OpenX::TestCase

  def client
    @client ||= OpenX::XmlrpcSessionClient.new(stub_session)
  end

  def stub_session
    stub(:url => "http://example.com/random/path", :id => 33)
  end

  def stub_xrc
    stub(:call => nil, :timeout= => 10)
  end

  test "call forwarding" do
    client.client.expects(:call).with('ox.getAgency', 33, 1)
    client.call('ox.getAgency', 1)
  end

  test "call rescueing" do
    a, b = stub_xrc, stub_xrc
    ::XMLRPC::Client.stubs(:new2).returns(a, b)

    a.expects(:call).once.raises(Net::HTTPBadResponse, 'Bad response')
    b.expects(:call).once.raises(XMLRPC::FaultException.new(0, 'session id is invalid'))
    client.session.expects(:recreate!).once

    client.call('ox.getAgency', 1)
    assert_not_equal  client.client, a
    assert_equal  client.client, b
  end

end
