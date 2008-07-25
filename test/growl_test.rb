require "rubygems"
require "test/unit"
require "test/spec"
require "mocha"

require File.expand_path('../../lib/growl', __FILE__)

describe 'Growl::Notifier' do
  it "should be a singleton class" do
    instance = Growl::Notifier.sharedInstance
    instance.should.be.instance_of Growl::Notifier
    instance.should.be Growl::Notifier.sharedInstance
  end
  
  it "should not respond to #alloc anymore" do
    Growl::Notifier.should.not.respond_to :alloc
  end
end
