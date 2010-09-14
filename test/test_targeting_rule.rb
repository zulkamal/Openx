require File.dirname(__FILE__) + '/helper'

class TargetingRuleTest < OpenX::TestCase

  test "is a Hash" do
    assert_kind_of Hash, rule
  end

  test "has a type" do
    assert_equal 'Geo:Region', rule['type']
  end

  test "raises exception on invalid type" do
    assert_raise(RuntimeError) { new_rule('Wrong') }
    assert_raise(RuntimeError) { new_rule('Geo:Wrong') }
    assert_nothing_raised { new_rule('deliveryLimitations:Geo:Country') }
  end

  test "accepts updates" do
    rule = new_rule.update('comparison' => '==')
    assert_instance_of TargetingRule, rule
    assert_equal({"logical"=>"and", "type"=>"Geo:Region", "comparison"=>"=="}, rule)
  end

  test "accessors" do
    rule = new_rule.logical('or').compare('==').with('GB|H9')
    assert_equal({"logical"=>"or", "type"=>"Geo:Region", "comparison"=>"==", "data" => "GB|H9"}, rule)
  end

  test "completeness" do
    assert !new_rule.complete?
    assert new_rule.logical('or').compare('==').with('GB|H9').complete?
  end

  test "instantiation" do
    assert_equal({
      "logical"=>"and", "data"=>"test", "type"=>"Site:Pageurl", "comparison"=>"=~"
    }, TargetingRule.instantiate(
      "logical"=>"and", "data"=>"test", "type"=>"deliveryLimitations:Site:Pageurl", "comparison"=>"=~"
    ))
  end

  test "comparisons" do
    assert_equal({"logical"=>"and", "type"=>"Geo:Region", "comparison"=>"==", "data" => "GB|H9"}, new_rule.eq?('GB|H9'))
    assert_equal({"logical"=>"and", "type"=>"Geo:Region", "comparison"=>"==", "data" => "GB|H9"}, new_rule.equal?('GB|H9'))
    assert_equal({"logical"=>"and", "type"=>"Geo:Region", "comparison"=>"==", "data" => "GB|H9"}, new_rule.is?('GB|H9'))

    assert_equal({"logical"=>"and", "type"=>"Geo:Region", "comparison"=>"!=", "data" => "GB|H9"}, new_rule.ne?('GB|H9'))
    assert_equal({"logical"=>"and", "type"=>"Geo:Region", "comparison"=>"!=", "data" => "GB|H9"}, new_rule.not_equal?('GB|H9'))
    assert_equal({"logical"=>"and", "type"=>"Geo:Region", "comparison"=>"!=", "data" => "GB|H9"}, new_rule.not?('GB|H9'))

    assert_equal({"logical"=>"and", "type"=>"Time:Day", "comparison"=>">", "data" => "3"}, new_rule('Time:Day') > '3')
    assert_equal({"logical"=>"and", "type"=>"Time:Day", "comparison"=>"<", "data" => "3"}, new_rule('Time:Day') < '3')
    assert_equal({"logical"=>"and", "type"=>"Time:Day", "comparison"=>">=", "data" => "3"}, new_rule('Time:Day') >= '3')
    assert_equal({"logical"=>"and", "type"=>"Time:Day", "comparison"=>"<=", "data" => "3"}, new_rule('Time:Day') <= '3')

    assert_equal({"logical"=>"and", "type"=>"Geo:Country", "comparison"=>"=~", "data" => "GB,US"}, new_rule('Geo:Country').include?('GB', 'US'))
    assert_equal({"logical"=>"and", "type"=>"Geo:Country", "comparison"=>"=~", "data" => "GB,US"}, new_rule('Geo:Country').contains?('GB', 'US'))
    assert_equal({"logical"=>"and", "type"=>"Geo:Country", "comparison"=>"!~", "data" => "GB,US"}, new_rule('Geo:Country').exclude?('GB', 'US'))

    assert_equal({"logical"=>"and", "type"=>"Geo:Region", "comparison"=>"=x", "data" => "GB.H\\d"}, new_rule.match?(/GB.H\d/))
    assert_equal({"logical"=>"and", "type"=>"Geo:Region", "comparison"=>"=x", "data" => "GB.H\\d"}, new_rule =~ /GB.H\d/)
    assert_equal({"logical"=>"and", "type"=>"Geo:Region", "comparison"=>"!x", "data" => "GB.H\\d"}, new_rule.no_match?(/GB.H\d/))
  end

  test 'combining' do
    rule = new_rule('Time:Day').gt?(3)
    assert_equal rule['logical'], 'and'
    rule = new_rule & rule
    assert_equal rule['logical'], 'and'
    rule = new_rule | rule
    assert_equal rule['logical'], 'or'
  end

  private

    def rule
      @rule ||= new_rule
    end

    def new_rule(type = 'Geo:Region')
      TargetingRule.new(type)
    end

end
