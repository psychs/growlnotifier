require File.expand_path('../test_helper', __FILE__)
require 'growl'
require 'growl_helpers'

class Foo < OSX::NSObject
  include Growl
end

describe "Growl, when mixed into a class" do
  before do
    @name = 'YourHamburgerIsReady'
    @title = 'Your hamburger is ready for consumption!'
    @description = 'Please pick it up at isle 4.'
    @options = { :sticky => true, :priority => 1 }
    
    @object = Foo.alloc.init
  end
  
  it "should define a #growl instance method" do
    @object.should.respond_to :growl
  end
  
  it "should call Growl::Notifier.sharedInstance.notify with the arguments passed to #growl" do
    should_call_sticky_notify_with_priority_1
    @object.growl @name, @title, @description, :sticky => true, :priority => 1
  end
  
  it "should define a #sticky_growl instance method which is a shortcut method to send a sticky Growl notification" do
    @object.should.respond_to :sticky_growl
  end
  
  it "should call Growl::Notifier.sharedInstance.notify with the arguments passed to #sticky_growl and the sticky option set to true" do
    should_call_sticky_notify_with_priority_1
    @object.sticky_growl @name, @title, @description, :priority => 1
  end
  
  private
  
  def should_call_sticky_notify_with_priority_1
    Growl::Notifier.sharedInstance.expects(:notify).with(@name, @title, @description, @options)
  end
end