require File.dirname(__FILE__) + '/helper'
require 'date'

class BannerTest < OpenX::TestCase

  test "destroy" do
    id = banner.id
    assert_nothing_raised {
      banner.destroy
    }
    assert_raises(XMLRPC::FaultException) {
      Banner.find(id)
    }
  end

  test "find" do
    assert_not_nil banner
    found = Banner.find(banner.id)
    assert_not_nil found
    assert_equal(banner, found)
  end

  test "update" do
    banner.name = 'super awesome'
    banner.save!

    found = Banner.find(banner.id)
    assert_equal('super awesome', found.name)
    found.destroy
  end

  test "find all" do
    banner = Banner.create!(init_params)
    list   = Banner.find(:all, banner.campaign.id)
    assert list.all? { |x| x.is_a?(Banner) }
    assert list.any? { |x| x == banner }
  end

  test "create" do
    banner = nil
    params = init_params
    assert_nothing_raised {
      banner = Banner.create!(params)
    }
    assert_not_nil banner
    params.each do |k,v|
      assert_equal(v, banner.send(:"#{k}"))
    end
  end

  test "create with JPEG" do
    banner = nil
    params = init_params.merge({
      :image => OpenX::Image.new(File.open(TEST_JPG, 'rb'))
    })
    assert_nothing_raised {
      banner = Banner.create!(params)
    }
    assert_not_nil banner
    params.each do |k,v|
      assert_equal(v, banner.send(:"#{k}"))
    end
  end

  test "getting/setting targeting" do
    assert_equal [], banner.targeting
    assert_nothing_raised {
      banner.targeting = targeting_rules
    }
    assert_equal targeting_rules, banner.targeting
  end

  private

  def init_params
    {
      :name         => "Banner-#{Time.now}",
      :storage_type => Banner::LOCAL_SQL,
      :campaign     => campaign,
      :url          => 'http://tenderlovemaking.com/',
      :file_name    => 'oogabooga',
      :image        => OpenX::Image.new(File.open(TEST_SWF, 'rb'))
    }
  end
end
