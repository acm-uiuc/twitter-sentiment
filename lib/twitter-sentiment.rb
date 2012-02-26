# Wrapper for including all the modules and classes found in twitter-sentiment package.
Dir[File.join("lib","**","*.rb")].each {|file| require file.split('/')[1..-1].join('/') }