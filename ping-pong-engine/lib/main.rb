require 'rubygems'
require 'bundler'
Bundler.setup
require 'ruote'
require 'ruote/storage/fs_storage'
require 'ruote-stomp'

# Setup an engine
engine = Ruote::Engine.new(
  Ruote::Worker.new(
    Ruote::FsStorage.new("ruote_data")
  )
)

## Configure AMQP
#{ :host => 'localhost',
#  :vhost => 'ruote',
#  :user => 'ruote',
#  :pass => 'ruote'
#}.each { |k,v|
#  AMQP.settings[k]=v
#}

# uncomment for lots of usefull information
#AMQP.logging = true

engine.noisy = true

# listen to the ruote_workitems queue for return-messages
receiver = RuoteStomp::Receiver.new(
  engine,
  :launchitems => false,
  :queue => "/queue/ruote_workitems"
)

# register ping and pong as participants to the game
engine.register_participant :ping, RuoteStomp::ParticipantProxy, :queue => "/queue/ping", :forget => false
engine.register_participant :pong, RuoteStomp::ParticipantProxy, :queue => "/queue/pong", :forget => false

# we need a crowd as well
engine.register_participant :logger do |workitem|
  puts "State: #{workitem.fields['state']}"
  puts "Count: #{workitem.fields['count']}"
end

# and we need some one to initiate the game
engine.register_participant :alpha do |wi|
  wi.fields['state'] = 'alpha'
  wi.fields['count'] = 0
end

# make 2 seperate MQ subscribers play ping pong with each other
pdef = Ruote.process_definition :name => 'game' do
  # the main definition
  sequence do
    setup
    repeat do
      play
      _break :if => '${f:count} >= 6'
    end
  end

  # setup shop by calling alpha and let the logger show the state
  define 'setup' do
    alpha
    logger
  end

  # perform a ping and a pong
  define 'play' do
    ping :command => "/ping/ping", :reply_queue => "/queue/ruote_workitems"
    logger
    pong :command => "/pong/pong", :reply_queue => "/queue/ruote_workitems"
    logger
  end

  # show the occurence of errors
  define :shout do
    echo 'Error occured...'
  end
end

wfid = engine.launch(pdef)
engine.wait_for(wfid)

# show the errors
errs = engine.errors
if errs.size > 0
  puts "there are processes with errors :"
  errs.each do |err|
  puts "process #{err.wfid}"
  end
end