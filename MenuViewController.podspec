#
# Be sure to run `pod lib lint MenuViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MenuViewController'
  s.version          = '0.1.6'
  s.summary          = 'MenuViewController is a Popover and/or Custom Menu View Controller.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
MenuViewController is a Popover and/or Custom Menu View Controller. It is easily configured and esthetically pleasing.
                       DESC

  s.homepage         = 'https://github.com/MatthewMerritt/MenuViewController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MatthewMerritt' => 'matthew.merritt@yahoo.com' }
  s.source           = { :git => 'https://github.com/MatthewMerritt/MenuViewController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.2'

  s.source_files = 'MenuViewController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MenuViewController' => ['MenuViewController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.swift_versions = ['5.0', '5.1']

end
