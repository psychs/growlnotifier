require File.expand_path('../test_helper', __FILE__)
require 'growl'

describe 'Growl::Notifier' do
  include GrowlNotifierSpecHelper
  
  before do
    set_variables!
    @instance.stubs(:send_registration!)
    @instance.register @name, @notifications
  end
  
  it "should be a singleton class" do
    @instance.should.be.instance_of Growl::Notifier
    @instance.should.be Growl::Notifier.sharedInstance
  end
  
  xit "should not create new instances anymore" do
    Growl::Notifier.should.not.respond_to :alloc
  end
end

describe 'Growl::Notifier#register' do
  include GrowlNotifierSpecHelper
  
  before do
    set_variables!
    @instance.stubs(:send_registration!)
    @instance.register @name, @notifications
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
    @instance.register @name, @notifications, @default_notifications
    @instance.default_notifications.should == @default_notifications
  end
  
  it "should by default use the NSAppication's sharedApplication icon if none was specified" do
    @instance.application_icon.should.be OSX::NSApplication.sharedApplication.applicationIconImage
  end
  
  it "should take an optional application icon" do
    @instance.register @name, @notifications, nil, @icon
    @instance.application_icon.should.be @icon
  end
  
  it "should register the configuration" do
    @instance.expects(:send_registration!)
    @instance.register @name, @notifications
  end
end

describe 'Growl::Notifier#send_registration!' do
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
    
    @instance.register @name, @notifications, @default_notifications, @icon
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
  
  it "should send a notification to Growl" do
    another_icon = mock('Another icon')
    
    dict = {
      :ApplicationName => @name,
      :ApplicationPID => @pid,
      :NotificationName => @notifications.first,
      :NotificationTitle => 'title',
      :NotificationDescription => 'description',
      :NotificationPriority => 1,
      :NotificationIcon => another_icon,
      :NotificationSticky => 1
    }
    
    @center.expects(:postNotificationName_object_userInfo_deliverImmediately).with(:GrowlNotification, nil, dict, true)
    
    @instance.notify(@notifications.first, 'title', 'description', :sticky => true, :priority => 1, :icon => another_icon)
  end
  
  it "should not require all options to be specified when sending a notification to Growl" do
    dict = {
      :ApplicationName => @name,
      :ApplicationPID => @pid,
      :NotificationName => @notifications.first,
      :NotificationTitle => 'title',
      :NotificationDescription => 'description',
      :NotificationPriority => 0
    }
    
    @center.expects(:postNotificationName_object_userInfo_deliverImmediately).with(:GrowlNotification, nil, dict, true)
    @instance.notify(@notifications.first, 'title', 'description')
  end
  
  it "should take a symbol instead of an integer to specify the priority level when sending a notification to Growl" do
    priority_table = { :very_low => -2, :moderate => -1, :normal => 0, :high => 1, :emergency => 2 }
    
    priority_table.each do |key, value|
      @center.expects(:postNotificationName_object_userInfo_deliverImmediately).with do |name, object, info, immediately|
        info[:NotificationPriority] == value
      end
      
      @instance.notify(@notifications.first, 'title', 'description', :priority => key)
    end
  end
  
  it "should add a callback to the callbacks if a block is given to #notify" do
    callback = proc { message_from_callback }
    @instance.notify(@notifications.first, 'title', 'description', &callback)
    @instance.instance_variable_get(:@callbacks)[callback.object_id]
  end
  
  it "should call a callback handler if the notification that it belongs to is clicked and then remove the callback" do
    callback = nil
    @instance.instance_eval do
      callback = proc { message_from_callback }
    end
    @instance.notify(@notifications.first, 'title', 'description', &callback)
    
    @instance.expects(:message_from_callback)
    @instance.onClicked(stubbed_notification(callback))
    @instance.instance_variable_get(:@callbacks)[callback.object_id].should.be nil
  end
  
  it "should send a message to the delegate if a notification was clicked" do
    notification = stubbed_notification
    assign_delegate.expects(:growlNotifier_notificationClicked).with(@instance, notification)
    @instance.onClicked(notification)
  end
  
  it "should not send a message to the delegate if a notification was clicked but the delegate doesn't respond to the delegate method" do
    assign_delegate
    @instance.onClicked(stubbed_notification)
  end
  
  it "should remove a callback handler if the notification that it belongs to times out" do
    callback = proc {}
    notification = stubbed_notification(callback)
    
    @instance.notify(@notifications.first, 'title', 'description', &callback)
    @instance.delegate = nil
    
    callback.expects(:call).times(0)
    @instance.onTimeout(notification)
    @instance.instance_variable_get(:@callbacks)[callback.object_id].should.be nil
  end
  
  it "should send a message to the delegate if a notification times out" do
    notification = stubbed_notification
    assign_delegate.expects(:growlNotifier_notificationTimedOut).with(@instance, notification)
    
    @instance.onTimeout(notification)
  end
  
  it "should not send a message to the delegate if a notification times out but the delegate doesn't respond to the delegate method" do
    assign_delegate
    @instance.onTimeout(stubbed_notification)
  end
  
  it "should resend the registration data to Growl if Growl was restarted for some reason" do
    @instance.expects(:send_registration!)
    @instance.onReady(nil)
  end
  
  private
  
  def assign_delegate
    delegate = mock('delegate')
    @instance.delegate = delegate
    delegate
  end
  
  def stubbed_notification(callback = nil)
    notification = stub('timeout notification')
    notification.stubs(:userInfo).returns("ClickedContext" => callback.object_id.to_s.to_ns)
    notification
  end
end