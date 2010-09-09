module OpenX
  module Services
    class TargetingRules < Array

      # Create a new targeting rule set. Example:
      #
      #    rules = OpenX::Services::TargetingRules.new do |t|
      #      t['Site:Pageurl'].include?('test') &
      #      t['Client:Ip'].match?(/^127\./) |
      #      t['Geo:Country'].include?('GB', 'US')
      #    end
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
