
Pod::Spec.new do |s|
  s.name     = 'JKImageView'
  s.version  = '0.0.1'
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.summary  = 'imageNet for your iOS app.'
  s.authors   = { 'Jack' => '369495368@qq.com' }
  s.source   = { :git => 'https://github.com/brasbug/JKImageView.git', :tag => s.version.to_s}
  s.homepage     = 'https://github.com/brasbug/JKImageView'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.description = 'blablabla'
  s.source_files = 'JKWebImageLoader/*.{h,m}'
  s.framework = 'ImageIO'
  s.requires_arc = true
  s.description  = <<-DESC
                    blalalalablalalalablalalalablalalalablalalalablalalalablalalalablalalala
                   DESC               
  s.dependency 'libwebp', '~>0.4.3'
             
end
