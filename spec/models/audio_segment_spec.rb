require 'spec_helper'

describe AudioSegment do
  before(:each) do
    @attrs = {:audio => 'This is the audio', :engine => 'text2audio', :play_order => 1, :delivery_id => 1}
  end

  it "should create a message if all the right attributes are provided" do
    AudioSegment.create!(@attrs)
  end

  describe "validations" do
    it "should require audio" do
      bad_audio_segment = AudioSegment.new(@attrs.merge(:audio => '    '))
      bad_audio_segment.should_not be_valid
    end

    it "should require an engine" do
      bad_audio_segment = AudioSegment.new(@attrs.merge(:engine => '    '))
      bad_audio_segment.should_not be_valid
    end

    it "should require a play_order" do
      bad_audio_segment = AudioSegment.new(@attrs.merge(:play_order => nil))
      bad_audio_segment.should_not be_valid
    end

    it "should require a delivery" do
      bad_audio_segment = AudioSegment.new(@attrs.merge(:delivery_id => nil))
      bad_audio_segment.should_not be_valid
    end

    it "should require a unique play_order/delivery combo" do
      AudioSegment.create!(@attrs)
      bad_audio_segment = AudioSegment.new(@attrs)
      bad_audio_segment.should_not be_valid
    end

    it "should allow play_order to be used again with different delivery" do
      AudioSegment.create!(@attrs)
      good_audio_segment = AudioSegment.new(@attrs.merge(:delivery_id => 2))
      good_audio_segment.should be_valid
    end

  end
end
