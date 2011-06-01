begin
  require 'json'
rescue LoadError
  $stderr.puts "Missing json gem. Please run 'bundle install'"
  exit 1
end

begin
  require 'stomp'
rescue LoadError
  $stderr.puts "Missing stomp gem. Please uncomment the amqp section in the Gemfile and run 'bundle install' if you wish to use the AMQP participant/listener pair in ruote"
end
