
Pod::Spec.new do |spec|
  spec.name         = 'MusicKit'
  spec.version      = '1.0.0'
  spec.summary      = 'MusicKit APP'
  spec.description  = 'MusicKit App ..'
  spec.homepage     = 'https://github.com/volcengine'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'author' => 'volcengine rtc' }
  spec.source       = { :path => './'}
  spec.ios.deployment_target = '9.0'
  
  spec.pod_target_xcconfig = {'CODE_SIGN_IDENTITY' => ''}
 
  spec.resources = ['Resource/*.{lic}']
  spec.vendored_frameworks = 'HFOpenApi.framework'
end
