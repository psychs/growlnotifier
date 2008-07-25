require "rubygems"
require "test/unit"
require "test/spec"
require "mocha"

require File.expand_path('../../lib/growl', __FILE__)

describe 'Growl::Notifier' do
  before do
    @instance = Growl::Notifier.sharedInstance
  end
  
  it "should be a singleton class" do
    @instance.should.be.instance_of Growl::Notifier
    @instance.should.be Growl::Notifier.sharedInstance
  end
  
  it "should not create new instances anymore" do
    Growl::Notifier.should.not.respond_to :alloc
  end
  
  it "should accept a delegate" do
    delegate = mock('The Notifiers shared instance delegate')
    @instance.delegate = delegate
    @instance.delegate.should.be delegate
  end
end
