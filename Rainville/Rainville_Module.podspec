
Pod::Spec.new do |spec|

  spec.name         = "Rainville_Module"
  spec.version      = "0.0.1"
  spec.summary      = "Rainville - iOS 's module ."

  spec.description  = <<-DESC
    Rainville - iOS
                   DESC

  spec.homepage     = "https://github.com/VArbiter/Rainville_iOS-iOS"

  # spec.license      = "MIT (example)"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  spec.author             = { "ElwinFrederick" => "elwinfrederick@163.com" }
  # Or just: spec.author    = "ElwinFrederick"
  # spec.authors            = { "ElwinFrederick" => "elwinfrederick@163.com" }

  # spec.platform     = :ios
  spec.platform     = :ios, "11.0"

  spec.source       = { :git => "https://github.com/VArbiter/Rainville_iOS-iOS.git", :tag => "#{spec.version}" }

  # spec.source_files  = "MQClasses", "Rainville_Module/MQClasses/**/*"
  # spec.exclude_files = "Classes/Exclude"
  spec.default_subspec = "MQRainville_Default"

  # spec.public_header_files = "Classes/**/*.h"

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # spec.framework  = "SomeFramework"
  spec.frameworks = "Foundation", "UIKit"

  spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  # spec.dependency 'MQExtensionKit' , '~> 4.1.9'
  # spec.dependency 'Masonry', '~> 1.1.0'

  spec.subspec "MQRainville_Default" do |dt|
    dt.dependency "Rainville_Module/MQRainville_Audios"
    dt.dependency "Rainville_Module/MQRainville_Pages"
    dt.dependency "Rainville_Module/MQRainville_Nets"
  end

  spec.subspec "MQRainville_Defines" do |dfs|
    dfs.dependency 'MQExtensionKit' , '~> 4.2.0-alpha'
    dfs.frameworks = "Foundation"
    dfs.source_files = 'MQRainville_Defines' , 'Rainville_Module/MQRainville_Defines/MQClasses/**/*'
    dfs.resource_bundles = {
      'MQRainville_Defines' => ['Rainville_Module/MQRainville_Defines/MQAssests/*']
    }
  end

  spec.subspec "MQRainville_Audios" do |ads|
    ads.dependency "Rainville_Module/MQRainville_Defines"
    ads.frameworks = "AVFoundation"
    ads.source_files = 'MQRainville_Audios' , 'Rainville_Module/MQRainville_Audios/MQClasses/**/*'
    ads.resource_bundles = {
      'MQRainville_Audios' => ['Rainville_Module/MQRainville_Audios/MQAssests/*']
    }
    ads.dependency "Rainville_Module/MQRainville_Defines"
  end

  spec.subspec "MQRainville_Pages" do |pgs|
    # pgs.dependency 'MQExtensionKit' , '~> 4.1.9'
    pgs.dependency "Rainville_Module/MQRainville_Defines"
    pgs.dependency 'Masonry', '~> 1.1.0'
    pgs.frameworks = "Foundation" , "UIKit" , "SafariServices" , "MessageUI"
    pgs.source_files = 'MQRainville_Pages' , 'Rainville_Module/MQRainville_Pages/MQClasses/**/*'
    pgs.resource_bundles = {
      'MQRainville_Pages' => ['Rainville_Module/MQRainville_Pages/MQAssests/*']
    }
  end

  spec.subspec "MQRainville_Nets" do |nts|
    nts.dependency "Rainville_Module/MQRainville_Defines"
    nts.frameworks = "Foundation"
    nts.source_files = 'MQRainville_Nets' , 'Rainville_Module/MQRainville_Nets/MQClasses/**/*'
  end

end
