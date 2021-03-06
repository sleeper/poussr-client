require 'spec_helper'

describe "poussr-client" do

  describe "configuration" do

    it "is not configured by default" do
      PoussrClient.host.should be_nil
      PoussrClient.port.should be_nil
    end

    it "can be configured through the :url method" do
      PoussrClient.url = "http://someserver.com:1234/base/of/the/api"
      PoussrClient.host.should == "someserver.com"
      PoussrClient.port.should == 1234
      PoussrClient.base.should == "/base/of/the/api"
    end

    it "should return url if asked so" do
      url = "http://someserver.com:1234/base/of/the/api"
      PoussrClient.url = url
      PoussrClient.url.should == URI.parse(url)
    end
    
    it "should use standard logger by default" do
      PoussrClient.logger.debug('foo')
      PoussrClient.logger.should be_kind_of(Logger)
    end

    it "can be configured to use any logger" do
      logger = mock("MyLogger")
      logger.should_receive(:debug).with('foo')
      PoussrClient.logger = logger
      PoussrClient.logger.debug('foo')
      PoussrClient.logger = nil
    end    
  end

  describe "when configured" do
    before do
      PoussrClient.url = "http://someserver.com:1234/base"
    end

    after do
      PoussrClient.host = nil
      PoussrClient.port = nil
      PoussrClient.base = nil
    end

    describe ".[]" do
      
      it "should return a channel" do
        PoussrClient['mychannel'].should be_kind_of(PoussrClient::Channel)
      end

      it "should reuse the same Channel object" do
        ch1 = PoussrClient['mychannel']
        ch2 = PoussrClient['mychannel']
        ch2.object_id.should == ch1.object_id
      end
      
      it "should pass the url to the Channel object" do
        ch1 = PoussrClient['thechannel']
        ch1.url.to_s.should match(PoussrClient.url.to_s)
      end

      it "should pass the name to the Channel object" do
        ch1 = PoussrClient['thechannel']
        ch1.name.should == 'thechannel'
      end
      
      
    end
    
  end

end
