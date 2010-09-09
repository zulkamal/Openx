require File.dirname(__FILE__) + '/helper'

class SessionTest < OpenX::TestCase

  test "has a URI" do
    assert_instance_of URI::HTTP, new_session.uri
  end

  test "has a URL" do
    assert_equal 'http://test.host/path/to/api', new_session('http://test.host/path/to/api').url
  end

  test "has a host" do
    assert_equal 'http://test.host', new_session('http://test.host/path/to/api').host
  end

  test "offers session-based API client (remote reference)" do
    assert_instance_of OpenX::XmlrpcSessionClient, new_session.remote
  end

  test "login working" do
    assert_nothing_raised { new_session.create(config['username'], config['password']) }
  end

  test "logout working" do
    assert_nothing_raised { new_session.create(config['username'], config['password']) }
    assert_not_nil new_session.id
    assert_nothing_raised { new_session.destroy }
    assert_nil new_session.id
  end

  private

    def config
      OpenX.configuration
    end

    def new_session(url = config['url'])
      @session ||= Session.new(url)
    end

end
