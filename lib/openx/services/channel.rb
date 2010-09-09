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

    end
  end
end
