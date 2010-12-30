require File.expand_path('../spec_helper', __FILE__)

describe PoussrClient::Channel do
    before do
      PoussrClient.url = "http://someserver.com:12345/base"
    end

    after do
      PoussrClient.host = nil
      PoussrClient.port = nil
      PoussrClient.base = nil
    end


  describe "trigger" do

    before :each do
      WebMock.disable_net_connect!
      WebMock.stub_request(
        :post, %r{/base/channels/mychannel/events}
      ).to_return(:status => 202)
      @channel = PoussrClient['mychannel']
    end
    
    it 'should try to talk to the configured host and port' do
      @channel.trigger('myevent', 'my data')
      WebMock.should have_requested(:post, %r{http://someserver.com:12345})
    end

    it 'should form correctly the needed URL'

    it 'should encode body as JSON'
    
  end

  describe "trigger_async" do
  end
  
end

