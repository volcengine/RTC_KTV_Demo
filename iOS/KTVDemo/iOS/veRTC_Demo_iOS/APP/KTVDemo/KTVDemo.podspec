Pod::Spec.new do |spec|
  spec.name         = 'KTVDemo'
  spec.version      = '1.0.0'
  spec.summary      = 'KTVDemo APP'
  spec.description  = 'KTVDemo App Demo..'
  spec.homepage     = 'https://github.com/volcengine'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'author' => 'volcengine rtc' }
  spec.source       = { :path => './' }
  spec.ios.deployment_target = '9.0'
  
  spec.source_files = '**/*.{h,m,c,mm,a}'
  spec.resource_bundles = {
    'KTVDemo' => ['Resource/*.xcassets']
  }
  spec.resources = ['Resource/*.{jpg}']
  spec.prefix_header_contents = '#import "Masonry.h"',
                                '#import "Core.h"',
                                '#import "KTVDemoConstants.h"',
                                '#import "KTVUserModel.h"',
                                '#import "KTVSeatModel.h"',
                                '#import "KTVRoomModel.h"',
                                '#import "KTVSongModel.h"'
                                
  spec.vendored_frameworks = 'HFOpenApi.framework'
  spec.dependency 'Core'
  spec.dependency 'YYModel'
  spec.dependency 'Masonry'
  spec.dependency 'VolcEngineRTC'
  spec.dependency 'SDWebImage'
end
