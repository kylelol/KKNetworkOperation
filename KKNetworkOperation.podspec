

Pod::Spec.new do |s|

  s.name         = "KKNetworkOperation"
  s.version      = "1.0"
  s.summary      = "A Operation subclass for making network requests."
  s.description  = "A subclassable Operation for making network requests."

  s.homepage     = "http://EXAMPLE/KKNetworkOperation"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = "Kyle Kirkland"
  s.platform     = :ios, "9.0"


  s.source       = { :git => "https://github.com/kylelol/KKNetworkOperation.git", :tag => "1.0" }

  s.source_files  = "NetworkOperation", "NetworkOperation/**/*.{h,m,swift}"

end
