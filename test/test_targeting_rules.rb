require File.dirname(__FILE__) + '/helper'

class TargetingRulesTest < OpenX::TestCase

  test "creating rules" do
    assert_equal [
      {"logical"=>"and", "type"=>"Site:Pageurl", "comparison"=>"=~", "data" => "test"},
      {"logical"=>"and", "type"=>"Client:Ip", "comparison"=>"=x", "data" => "^127\\."},
      {"logical"=>"or",  "type"=>"Geo:Country", "comparison"=>"=~", "data" => "GB,US"}
    ], targeting_rules
  end

end
