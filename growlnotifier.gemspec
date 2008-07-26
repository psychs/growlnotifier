Gem::Specification.new do |s|
  s.name = 'growlnotifier'
  s.version = '1.0'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Growl::Notifier is a OSX RubyCocoa class that allows your application to post notifications to the Growl daemon.'
  
  s.files = Dir.glob("{lib,test}/*.rb") + %w(README LICENSE)
  s.require_path = 'lib'
  s.has_rdoc = true
  
  s.authors = ["Satoshi Nakagawa", "Eloy Duran"]
  s.email = ["psychs@limechat.net", "e.duran@superalloy.nl"]
  s.homepage = "http://github.com/psychs/growlnotifier/tree/master"
  s.rubyforge_project = "growlnotifier"
end