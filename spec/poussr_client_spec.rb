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

end
