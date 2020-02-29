Pod::Spec.new do |s|
  s.name     = 'TOAppRater'
  s.version  = '1.0'
  s.license  =  { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'A way to subtly remind users to rate your app.'
  s.homepage = 'https://github.com/TimOliver/TOClassyAppRater'
  s.author   = 'Tim Oliver'
  s.source   = { :git => 'https://github.com/TimOliver/TOAppRater.git', :tag => s.version }
  s.platform = :ios, '7.0'
  s.source_files = 'TOClassyAppRater/**/*.{h,m}'
  s.resource_bundles = {
    'TOAppRaterBundle' => ['TOAppRater/**/*.lproj']
  }
  s.requires_arc = true
  s.framework = 'StoreKit'
end
