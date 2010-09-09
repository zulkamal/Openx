module OpenX
  module Services

    # Create targeting rule sets. Example:
    #
    #    rules = OpenX::Services::TargetingRules.new do |t|
    #      t['Site:Pageurl'].include?('test') &
    #      t['Client:Ip'].match?(/^127\./) |
    #      t['Geo:Country'].include?('GB', 'US')
    #    end
    class TargetingRules < Array

      def initialize(&block)
        super([])
        block.call(self)
      end

      def [](key)
        rule = TargetingRule.new(key)
        push(rule)
        rule
      end

    end
  end
end
