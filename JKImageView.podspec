Pod::Spec.new do |s|

  s.name         = "JKImageView"
  s.version      = "0.0.1"
  s.summary      = "A short description of JKImageView."

  s.homepage     = "http://www.flywithme.top"
  s.license      = "MIT"

  s.author             = { "Jack" => "erfeng.cheng@dianping.com" }


  s.platform     = :ios
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/brasbug/SDWebImage.git", :tag => "0.0.1" }
  s.source_files  = "JKImageView/*.{h,m}"
  s.framework  = "UIKit"


end
