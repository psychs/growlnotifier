require 'osx/cocoa'
require File.expand_path('../../lib/growl', __FILE__)

class GrowlController < OSX::NSObject
  HELLO_TYPE = 'Hello message received'
  
  def init
    if super_init
      @g = Growl::Notifier.sharedInstance
      @g.delegate = self
      @g.register('GrowlSample', [HELLO_TYPE])
      @g.notify(HELLO_TYPE, 'Sticky', 'Hello world', :sticky => true, :click_context => Time.now.to_s )
      @g.notify(HELLO_TYPE, 'Timed out', 'Hello world', :click_context => Time.now.to_s )
      @count = 2
      self
    end
  end

  def growlNotifier_notificationClicked(sender, context)
    puts "Clicked: #{context}"
    checkCount
  end

  def growlNotifier_notificationTimedOut(sender, context)
    puts "Timed out: #{context}"
    checkCount
  end
  
  def checkCount
    @count -= 1
    OSX::NSApp.terminate(nil) if @count == 0
  end
end

g = GrowlController.alloc.init
OSX::NSApp.run
