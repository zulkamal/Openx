module OpenX
  module Services
    class Channel < Base

      openx_accessor :name          => :channelName,
                     :id            => :channelId,
                     :comments      => :comments,
                     :description   => :description,
                     :publisher_id  => :websiteId,
                     :agency_id     => :agencyId

      has_one        :publisher

      self.create   = 'ox.addChannel'
      self.update   = 'ox.modifyChannel'
      self.delete   = 'ox.deleteChannel'
      self.find_one = 'ox.getChannel'
      self.find_all = 'ox.getChannelListByWebsiteId'

      def initialize(params = {})
        raise "need publisher" unless params[:publisher_id] || params[:publisher]
        params[:publisher_id] ||= params[:publisher].id
        super(params)
      end

      def targeting
        raise "Channel must be saved" if new_record?
        remote.call("ox.getChannelTargeting", self.id).map do |line|
          TargetingRule.instantiate(line)
        end
      end

      def set_targeting(rules)
        raise "Channel must be saved" if new_record?
        remote.call("ox.setChannelTargeting",  self.id, rules)
      end

    end
  end
end
