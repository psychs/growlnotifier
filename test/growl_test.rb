require "rubygems"
require "test/unit"
require "test/spec"
require "mocha"

require File.expand_path('../../lib/growl', __FILE__)

describe 'Growl::Notifier#start' do
  before do
    @instance = Growl::Notifier.sharedInstance
    
    @name = 'GrowlerApp'
    @icon = mock('PrettyIcon')
    @notifications = ['YourHamburgerIsReady', 'OhSomeoneElseAteIt']
    @default_notifications = ['ADefaultNotification', *@notifications]
    
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
end

describe 'Growl::Notifier' do
  before do
    @instance = Growl::Notifier.sharedInstance
    
    @name = 'GrowlerApp'
    @icon = mock('Icon')
    @notifications = ['YourHamburgerIsReady', 'OhSomeoneElseAteIt']
    @default_notifications = ['ADefaultNotification', *@notifications]
  end
  
  it "should be a singleton class" do
    @instance.should.be.instance_of Growl::Notifier
    @instance.should.be Growl::Notifier.sharedInstance
  end
  
  it "should not create new instances anymore" do
    Growl::Notifier.should.not.respond_to :alloc
  end
  
  xit "should accept a delegate" do
    delegate = mock('The Notifiers shared instance delegate')
    @instance.delegate = delegate
    @instance.delegate.should.be delegate
  end
end
