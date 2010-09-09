require File.dirname(__FILE__) + '/helper'
require 'fileutils'

class BaseTest < OpenX::TestCase

  def teardown
    Base.connection = nil
  end

  test "uses (shared) default connection" do
    assert_equal OpenX::Services.default_connection, Base.connection
    assert_equal Base.connection, Banner.connection
  end

  test "can use custom connection" do
    Base.establish_connection(OpenX.configuration)

    assert_not_equal OpenX::Services.default_connection, Base.connection
    assert_not_equal Base.connection, Banner.connection
  end

  test "can temporarily use a custom connection" do
    assert_equal OpenX::Services.default_connection, Base.connection
    assert_equal Base.connection, Banner.connection

    Base.with_connection(OpenX.configuration) do
      assert_not_equal OpenX::Services.default_connection, Base.connection
      assert_not_equal Base.connection, Banner.connection
    end

    assert_equal OpenX::Services.default_connection, Base.connection
    assert_equal Base.connection, Banner.connection
  end

  test "has remote client reference" do
    assert_instance_of OpenX::XmlrpcSessionClient, Base.remote
    assert_equal Banner.remote, Base.remote
  end

end
