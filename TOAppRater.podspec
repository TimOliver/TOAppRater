Pod::Spec.new do |s|
  s.name     = 'TOAppRater'
  s.version  = '2.0.0'
  s.license  =  { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'A way to subtly remind users to rate your app.'
  s.homepage = 'https://github.com/TimOliver/TOAppRater'
  s.author   = 'Tim Oliver'
  s.source   = { :git => 'https://github.com/TimOliver/TOAppRater.git', :tag => s.version }
  s.platform = :ios, '9.0'
  s.source_files = 'TOAppRater/**/*.{h,m}'
  s.resource_bundles = {
    'TOAppRaterBundle' => ['TOAppRater/**/*.lproj']
  }
  s.requires_arc = true
  s.framework = 'StoreKit'
end
