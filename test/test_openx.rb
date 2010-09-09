require File.dirname(__FILE__) + '/helper'

class OpenXTest < OpenX::TestCase

  test "has an env" do
    assert_equal 'test', OpenX.env
  end

  test "has an configuration" do
    assert_instance_of Hash, OpenX.configuration
  end

  test "has config file location" do
    assert File.exist?(OpenX.config_file)
  end

end
