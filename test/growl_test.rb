require "rubygems"
require "test/unit"
require "test/spec"
require "mocha"

require File.expand_path('../../lib/growl', __FILE__)

module GrowlNotifierSpecHelper
  def set_variables!
    @instance = Growl::Notifier.sharedInstance
    @name = 'GrowlerApp'
    @icon = mock('PrettyIcon')
    @notifications = ['YourHamburgerIsReady', 'OhSomeoneElseAteIt']
    @default_notifications = ['ADefaultNotification', *@notifications]
    
    @center = OSX::NSDistributedNotificationCenter.defaultCenter
  end
end

describe 'Growl::Notifier' do
  include GrowlNotifierSpecHelper
  
  before do
    set_variables!
    @instance.stubs(:register!)
    @instance.start @name, @notifications
  end
  
  it "should be a singleton class" do
    @instance.should.be.instance_of Growl::Notifier
    @instance.should.be Growl::Notifier.sharedInstance
  end
  
  xit "should not create new instances anymore" do
    Growl::Notifier.should.not.respond_to :alloc
  end
end

describe 'Growl::Notifier#start' do
  include GrowlNotifierSpecHelper
  
  before do
    set_variables!
    @instance.stubs(:register!)
    @instance.start @name, @notifications
  end
  
  it "should take the name of the application" do
    @instance.application_name.should == @name
  end
  
  it "should take an array of notifications that should be registered" do
    @instance.notifications.should == @notifications
  end
  
  it "should set the default notifications to the same as the notifications array if none is specified" do
    @instance.default_notifications.should == @notifications
  end
  
  it "should take an array of notifications that should be registered as the default notifications" do
    @instance.start @name, @notifications, @default_notifications
    @instance.default_notifications.should == @default_notifications
  end
  
  it "should by default use the NSAppication's sharedApplication icon if none was specified" do
    app_icon = mock('NSApp Icon')
    OSX::NSApplication.sharedApplication.stubs(:applicationIconImage).returns(app_icon)
    
    @instance.application_icon.should.be app_icon
  end
  
  it "should take an optional application icon" do
    @instance.start @name, @notifications, nil, @icon
    @instance.application_icon.should.be @icon
  end
  
  it "should register the configuration" do
    @instance.expects(:register!)
    @instance.start @name, @notifications
  end
end

describe 'Growl::Notifier#register' do
  include GrowlNotifierSpecHelper
  
  before do
    set_variables!
    @tiff = mock('TIFFRepresentation')
    @icon.stubs(:TIFFRepresentation).returns(@tiff)
  end
  
  it "should register itself with Growl" do
    pid = 54231
    @instance.stubs(:pid).returns(pid)
    
    @instance.expects(:add_observer).with('onReady:', "Lend Me Some Sugar; I Am Your Neighbor!", false)
    @instance.expects(:add_observer).with('onClicked:', "GrowlClicked!", true)
    @instance.expects(:add_observer).with('onTimeout:', "GrowlTimedOut!", true)
    
    dict = {
      :ApplicationName => @name,
      :ApplicationIcon => @tiff,
      :AllNotifications => @notifications,
      :DefaultNotifications => @default_notifications
    }
    
    @center.expects(:objc_send).with(
      :postNotificationName, :GrowlApplicationRegistrationNotification,
                    :object, nil,
                  :userInfo, dict,
        :deliverImmediately, true
    )
    
    @instance.start @name, @notifications, @default_notifications, @icon
  end
end

describe "Growl::Notifier.sharedInstance" do
  include GrowlNotifierSpecHelper
  
  before do
    set_variables!
    
    @pid = 54231
    OSX::NSProcessInfo.processInfo.stubs(:processIdentifier).returns(@pid)
  end
  
  it "should return the applications PID" do
    @instance.send(:pid).should.be @pid
  end
  
  it "should be able to easily add observers to the NSDistributedNotificationCenter" do
    @center.expects(:addObserver_selector_name_object).with(@instance, 'selector:', "name", nil)
    @instance.send(:add_observer, 'selector:', 'name', false)
    
    @center.expects(:addObserver_selector_name_object).with(@instance, 'selector:', "#{@name}-#{@pid}-name", nil)
    @instance.send(:add_observer, 'selector:', 'name', true)
  end
end