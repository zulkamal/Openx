require File.dirname(__FILE__) + '/helper'

class ServicesTest < OpenX::TestCase

  test "has a default connection" do
    assert_instance_of OpenX::Services::Session, OpenX::Services.default_connection
  end

  test "can establish new connections" do
    default = OpenX::Services.default_connection
    clone   = OpenX::Services.establish_connection(OpenX.configuration)
    assert_equal OpenX::Services.default_connection, default
    assert_not_equal OpenX::Services.default_connection, clone
  end

end
