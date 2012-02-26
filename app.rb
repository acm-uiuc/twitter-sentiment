# Add lib/ folder to end of the Ruby library search path so we can simply require them like gems
$:.push File.join(File.dirname(__FILE__),'lib')

