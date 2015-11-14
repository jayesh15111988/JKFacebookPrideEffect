Pod::Spec.new do |s|
  s.name          = 'JKFacebookPrideEffect'
  s.version       = '0.0.8'
  s.license       = 'MIT'
  s.summary       = 'Facebook style Pride parade effect'
  s.homepage      = 'https://github.com/jayesh15111988'
  s.author        = 'Jayesh Kawli'
  s.source        = {  :git => 'git@github.com:jayesh15111988/JKFacebookPrideEffect.git', :tag => "#{s.version}" }
  s.source_files  = 'JKFacebookPrideEffect/Classes/**/*'
  s.requires_arc  = true
  s.ios.deployment_target = '7.0'
  #s.resources = 'Graphics/*.png'
end
