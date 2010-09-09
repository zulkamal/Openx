require File.dirname(__FILE__) + '/helper'

class ChannelTest < OpenX::TestCase

  test "create" do
    channel = Channel.create!(params)
    assert_not_nil channel
    params.each do |k,v|
      assert_equal(v, channel.send(:"#{k}"))
    end
    channel.destroy
  end

  test "find" do
    found = Channel.find(channel.id)
    assert_not_nil found
    assert_equal(channel, found)
  end

  test "find_all" do
    channel # Create one
    channels = Channel.find(:all, publisher.id)
    assert_equal channels.sort, publisher.channels.sort
    assert_equal 1, channels.size
  end

  test "destroy" do
    assert_not_nil channel
    id = channel.id
    assert_nothing_raised {
      channel.destroy
    }
    assert_raises(XMLRPC::FaultException) {
      Channel.find(id)
    }
  end

  test "update" do
    channel
    channel.name = 'tenderlove'
    channel.save!

    found = Channel.find(channel.id)
    assert_equal('tenderlove', found.name)
  end

  test "getting/setting targeting" do
    assert_equal [], channel.targeting
    assert_nothing_raised {
      channel.set_targeting(targeting_rules)
    }
    assert_equal targeting_rules, channel.targeting
  end

  private

    def params
      @params ||= {
        :publisher   => publisher,
        :name        => "Channel - #{Time.now}",
        :comments    => 'Random Comments',
        :description => 'Random Description'
      }
    end
end
