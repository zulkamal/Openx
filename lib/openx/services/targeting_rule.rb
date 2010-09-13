module OpenX
  module Services

    class TargetingRule < Hash
      TYPES = {
        'Client'  => %w(Browser Domain Ip Language Os Useragent),
        'Geo'     => %w(Areacode City Continent Country Dma Latlong Netspeed Organisation Postalcode Region),
        'Site'    => %w(Channel Pageurl Referingpage Source Variable),
        'Time'    => %w(Date Day Hour)
      }.freeze

      DATA_KEYS = ['comparison', 'data', 'logical'].freeze
      ALL_KEYS  = (DATA_KEYS + ['type']).freeze

      attr_reader :type

      def self.instantiate(hash)
        rule = new(hash['type'])
        DATA_KEYS.each {|k| rule.update k => hash[k] }
        rule
      end

      def initialize(type)
        super().update('type' => verify_type(type), 'logical' => 'and')
      end

      def equal?(value)
        update 'comparison' => '==', 'data' => convert(value)
      end
      alias_method :eq?, :equal?
      alias_method :is?, :equal?
      alias_method :==,  :equal?

      def not_equal?(value)
        update 'comparison' => '!=', 'data' => convert(value)
      end
      alias_method :ne?,  :not_equal?
      alias_method :not?, :not_equal?

      def lt?(value)
        update 'comparison' => '<', 'data' => convert(value)
      end
      alias_method :<,  :lt?

      def gt?(value)
        update 'comparison' => '>', 'data' => convert(value)
      end
      alias_method :>,  :gt?

      def lte?(value)
        update 'comparison' => '<=', 'data' => convert(value)
      end
      alias_method :<=,  :lte?

      def gte?(value)
        update 'comparison' => '>=', 'data' => convert(value)
      end
      alias_method :>=,  :gte?

      def match?(value)
        update 'comparison' => '=x', 'data' => convert(value)
      end
      alias_method :=~, :match?

      def &(other)
        other.logical('and')
      end

      def |(other)
        other.logical('or')
      end

      def no_match?(value)
        update 'comparison' => '!x', 'data' => convert(value)
      end

      def include?(*values)
        update 'comparison' => '=~', 'data' => convert(values)
      end
      alias_method :contains?, :include?

      def exclude?(*values)
        update 'comparison' => '!~', 'data' => convert(values)
      end
      alias_method :does_not_contain?, :exclude?

      def with(value)
        update 'data' => convert(value)
      end

      def compare(value)
        update 'comparison' => value
      end

      def logical(value)
        value = value.to_s
        update 'logical' => (value == 'or' ? value : 'and')
      end

      def complete?
        values_at(*ALL_KEYS).all? {|v| !v.nil? }
      end

      private

        def verify_type(type)
          group, component = type.to_s.split(':').last(2)
          raise "Invalid type '#{self['type']}'" unless TYPES.key?(group) && TYPES[group].include?(component)
          "#{group}:#{component}"
        end

        def convert(value)
          case value
          when Array
            value.map {|v| convert(v) }.join(',')
          when Regexp
            value.source
          else
            value.to_s
          end
        end

    end
  end
end
