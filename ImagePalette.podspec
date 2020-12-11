Pod::Spec.new do |s|
  s.name         = "ImagePalette"
  s.version      = "0.1.0"
  s.summary      = "Swift/iOS port of Android’s Palette"
  s.homepage     = "https://github.com/shnhrrsn/ImagePalette"
  s.license      = "Apache License 2.0"

  s.author       = "Shaun Harrison"
  s.social_media_url = "http://twitter.com/shnhrrsn"

  s.platform     = :ios, "8.0"
  s.source       = {
    :git => "https://github.com/shnhrrsn/ImagePalette.git",
    :tag => s.version
  }
  s.source_files = "src/*.swift"
  s.requires_arc = true

  s.dependency 'SwiftPriorityQueue', '~> 1.3.1'
end
