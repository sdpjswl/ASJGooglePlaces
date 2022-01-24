Pod::Spec.new do |s|
  s.name          = 'ASJGooglePlaces'
  s.version       = '1.1'
  s.platform      = :ios, '9.0'
  s.license       = { :type => 'MIT' }
  s.homepage      = 'https://github.com/sdpjswl/ASJGooglePlaces'
  s.authors       = { 'Sudeep' => 'sdpjswl1@gmail.com' }
  s.summary       = 'A few operations using the Google Places and Maps Directions REST APIs'
  s.source        = { :git => 'https://github.com/sdpjswl/ASJGooglePlaces.git', :tag => s.version }
  s.source_files  = 'ASJGooglePlaces/**/*.*'
  s.frameworks    = 'CoreLocation'
  s.requires_arc  = true
end
