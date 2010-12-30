require File.expand_path('../spec_helper', __FILE__)


describe PoussrClient::Request do

  it "should correctly encode the query" do
    r = PoussrClient::Request.new('myevt', 'my data')
    r.query.should == 'name=myevt'    
  end

  it "should not touch to 'String' body" do
    r = PoussrClient::Request.new('myevt', 'my data')
    r.body.should == 'my data'
  end
  

  it "should JSONify non-'String' body" do
    data =  {'id' => 43}
    r = PoussrClient::Request.new('myevt',data)
    r.body.should == JSON.generate(data)
  end
  
end
