#
# Be sure to run `pod lib lint OrderedJSONSerialization.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OrderedJSONSerialization'
  s.version          = '1.0.6'
  s.summary          = 'For some reason, neither Apple, nor any other JSON serialization library for Swift supports ordered JSON. This fixes it.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  For some reason, neither Apple, nor any other JSON serialization library for Swift supports ordered JSON. This fixes it.
  Even though the JSON RFC specifies that the order is not important for JSON documents, in some cases, ordering is desired.
  With Swift's native .sortedKeys WritingOption, this is partially supported, but only on the top-level of the document.
  Given Dictionary's unsorted fashion of storing items, when using JSON documents as queries, this randomness preventsa caching
  on a CDN. For this case, there's OrderedJSONSerialization.
                       DESC

  s.homepage         = 'https://github.com/rafaelc0sta/OrderedJSONSerialization'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rafael Costa' => 'rafael@rafaelcosta.me' }
  s.source           = { :git => 'https://github.com/rafaelc0sta/OrderedJSONSerialization.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/merafaelcosta'


  s.platforms = { :ios => "8.0", :tvos => "10.0" }
  # s.ios.deployment_target = '8.0'
  s.swift_version = '5.0'

  s.source_files = 'OrderedJSONSerialization/Classes/**/*'
end
