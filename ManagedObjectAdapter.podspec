#
#  Created by teambition-ios on 2020/7/27.
#  Copyright © 2020 teambition. All rights reserved.
#     

Pod::Spec.new do |s|
  s.name             = 'ManagedObjectAdapter'
  s.version          = '0.0.7'
  s.summary          = 'ManagedObjectAdapter is a lightweight adapter for the converts between Model instances and Core Data managed objects.'
  s.description      = <<-DESC
  ManagedObjectAdapter is a lightweight adapter for the converts between Model instances and Core Data managed objects.
                       DESC

  s.homepage         = 'https://github.com/teambition/ManagedObjectAdapter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'teambition mobile' => 'teambition-mobile@alibaba-inc.com' }
  s.source           = { :git => 'https://github.com/teambition/ManagedObjectAdapter.git', :tag => s.version.to_s }

  s.swift_version = '5.0'
  s.ios.deployment_target = '8.0'

  s.source_files = 'ManagedObjectAdapter/*.swift'

end
