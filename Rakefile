$: << File.join(File.dirname(__FILE__), "lib")

require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'openx'

Rake::TestTask.new(:test) do |test|
  test.test_files = FileList["test/**/test_*.rb"].sort
  test.libs << "test"
  test.verbose = false
  test.warning = true
end

task :default => :test

namespace :openx do
  task :clean do
    ENV['OPENX_ENV'] = 'test'
    include OpenX::Services

    Agency.find(:all) do |agency|
      Advertiser.find(:all, agency.id).each do |advertiser|
        Campaign.find(:all, advertiser.id).each do |campaign|
          Banner.find(:all, campaign.id).each do |banner|
            banner.destroy
          end
          campaign.destroy
        end
        advertiser.destroy
      end
    end

  end
end


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "bsm-openx"
    gemspec.summary = "A Ruby interface to the OpenX XML-RPC API"
    gemspec.description = "A Ruby interface to the OpenX XML-RPC API"
    gemspec.email = "dimitrij@blacksquaremedia.com"
    gemspec.homepage = "http://github.com/bsm/openx"
    gemspec.authors = ["Aaron Patterson", "Andy Smith", "TouchLocal P/L", "Dimitrij Denissenko"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
