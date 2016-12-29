Pod::Spec.new do |s|
  s.name         = "RxStateFlow"
  s.version      = "1.0.2"
  s.summary      = "Persistent Reactive Unidirectional Date Flow with Realm and RxSwift."
  s.description  = <<-DESC
  An implementation of a Persistent Reactive Unidirectional Date Flow using Realm and RxSwift.

  RxStateFlow provides an architecture where the core idea is that your code is built around a `Model` of your application state, a way to `update` your model, and a way to `view` your model.

  Using RxStateFlow makes it very easy to have the app state  persist (between app launches), reactive and accessible across classes and threads.
                   DESC
  s.homepage     = "https://github.com/mmadjer/RxStateFlow"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Miroslav Valkovic-Madjer" => "miro.madjer@gmail.com" }
  s.social_media_url   = "http://twitter.com/miromadjer"
  s.platform     = :ios, "10.0"
  s.ios.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/mmadjer/RxStateFlow.git", tag: s.version.to_s }
  s.source_files = 'Sources/**/*.{swift}'
  s.requires_arc = true
  s.dependency "RxSwift", "~> 3.0"
  s.dependency "RealmSwift", "~> 2.0"

end
