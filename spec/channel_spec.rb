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

  it "should be passed the URL" do
    ch = PoussrClient['mychannel']
    ch.url.should == PoussrClient.url
  end

  it "should be passed the channel name" do
    ch = PoussrClient['mychannel']
    ch.name.should == 'mychannel'
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

    it 'should form correctly the needed URL' do
      @channel.trigger('myevent', 'my data')
      WebMock.should have_requested(:post, %r{http://someserver.com:12345}).with do |req|
        req.path = PoussrClient.url.path + "/channels/mychannel/events"
        req.body = 'my data'
        req.query = 'name=myevent'
        req.headers = {'Content-Type' => 'application/json'}
      end
    end

    it 'should encode body as JSON' do
      data = {"id" => 43}
      @channel.trigger('myevent', data)
      WebMock.should have_requested(:post, %r{http://someserver.com:12345}).with( :body => JSON.generate(data))
    end

    it 'should return true if 202 is received' do
      @channel.trigger('myevent', 'my data').should be_true      
    end

    it 'should return false and log in case of error' do
      WebMock.stub_request(
        :post, %r{/base/channels/mychannel/events}
                           ).to_return(:status => 400)
      logger = double('logger')
      logger.should_receive(:error)
      old_logger = PoussrClient.logger
      PoussrClient.logger = logger
      @channel.trigger('myevent', 'my data').should be_false
      PoussrClient.logger = old_logger
    end
    
  end

  describe "trigger_async" do
    # before :each do
    #   WebMock.reset_webmock
    #   WebMock.disable_net_connect!

    #   @url_regexp = %r{/base/channels/mychannel/events}
    # end

    # it 'should try to talk to the configured host and port' do
    #   EM.run {
    #     stub_request(:post, @url_regexp).to_return(:status => 202)
    #     channel = PoussrClient::Channel.new(PoussrClient.url, 'mychannel')
    #     channel.trigger_async('myevent', 'my data').callback {
    #       WebMock.should have_requested(:post, %r{http://someserver.com:12345})
    #       EM.stop
    #     }
    #   }
    # end
    
  end

end

