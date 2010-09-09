require 'yaml'

module OpenX
  module Services
    autoload :Persistance, 'openx/services/persistance'
    autoload :Base, 'openx/services/base'
    autoload :Session, 'openx/services/session'
    autoload :Advertiser, 'openx/services/advertiser'
    autoload :Agency, 'openx/services/agency'
    autoload :Campaign, 'openx/services/campaign'
    autoload :Banner, 'openx/services/banner'
    autoload :Publisher, 'openx/services/publisher'
    autoload :Zone, 'openx/services/zone'
    autoload :Channel, 'openx/services/channel'

    @@connection = nil

    # Default connection
    def self.default_connection
      @@connection ||= establish_connection(OpenX.configuration)
    end

    def self.establish_connection(config)
      connection = Session.new(config['url'])
      connection.create config['username'], config['password']
      connection
    end

  end
end
