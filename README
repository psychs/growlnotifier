= Growl Notifier

== Overview

Growl::Notifier is a class that allows your application to post notifications to the Growl daemon.
It can also receive clicked and timeout notifications as well as take blocks for clicked callback handlers.

This is an extraction and cleanup of the Growl code from LimeChat (http://github.com/psychs/limechat/tree/master) and later on extended for WebApp (http://github.com/alloy/webapp-app/tree/master).

== Requirements

* Mac OS X 10.4 or 10.5
* Ruby 1.8 (http://ruby-lang.org/)
* RubyCocoa (http://rubycocoa.sourceforge.net/)

== How to use Growl Notifier

A simple example:

  require 'growl'
  
  g = Growl::Notifier.sharedInstance
  g.register('test_app', ['message_type'])
  g.notify('message_type', 'title', 'desc')

How to receive clicked and timeout notifications in your application:

  require 'growl'

  class GrowlController < OSX::NSObject
    def init
      if super_init
        @g = Growl::Notifier.sharedInstance
        @g.delegate = self
        @g.register('test_app', ['message_type'])
        @g.notify('message_type', 'title', 'desc')
        self
      end
    end

    def growlNotifierClicked_context(sender, context)
      puts context
    end

    def growlNotifierTimedOut_context(sender, context)
      puts context
    end
  end

Include the Growl module into your class to get access to a few convenience methods:

  require 'growl'

  class GrowlController < OSX::NSObject
    include Growl
    Growl::Notifier.sharedInstance.register('test_app', ['message_type'])
    
    def init
      if super_init
        growl('message_type', 'title', 'desc')
        self
      end
    end
  end

== License

Copyright (c) 2007-2008 Satoshi Nakagawa <psychs@limechat.net>, Eloy Duran <e.duran@superalloy.nl>
You can redistribute it and/or modify it under the same terms as Ruby.