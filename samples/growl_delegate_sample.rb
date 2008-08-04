require 'rubygems'
require 'growl'

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

  def growlNotifierClicked_context(sender, context)
    puts "Clicked: #{context}"
    checkCount
  end

  def growlNotifierTimedOut_context(sender, context)
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
