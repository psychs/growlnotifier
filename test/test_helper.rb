require "rubygems"
require "test/unit"
require "test/spec"
require "mocha"
require 'osx/cocoa'

def OSX._ignore_ns_override; true; end

$: << File.expand_path('../../lib', __FILE__)

module GrowlNotifierSpecHelper
  def set_variables!
    @instance = Growl::Notifier.sharedInstance
    @name = 'GrowlerApp'
    @icon = mock('PrettyIcon')
    @notifications = ['YourHamburgerIsReady', 'OhSomeoneElseAteIt']
    @default_notifications = ['ADefaultNotification', *@notifications]
    
    @center = mock('NSDistributedNotificationCenter')
    @center.stubs(:postNotificationName_object_userInfo_deliverImmediately)
    OSX::NSDistributedNotificationCenter.stubs(:defaultCenter).returns(@center)
  end
end