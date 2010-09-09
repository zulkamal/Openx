$: << File.join(File.dirname(__FILE__), "lib")

require 'rubygems'
require 'bundler'

Bundler.setup
Bundler.require

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
