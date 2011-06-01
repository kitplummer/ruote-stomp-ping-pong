This is a port of the ruote-amqp-ping-pong investigation:

https://github.com/coffeeaddict/ruote-amqp-ping-pong

but using Stomp instead of AMQP.

Clone this project.

Open a 3 terminal windows and cd into each subdirectory [ping/, pong,
ping-pong-engine/].

In each terminal window run 'bundle', to fetch the gem dependencies.

From ping/, run 'bin/ping'

From pong/, run 'bin/pong'

From ping-pong-engine/, run 'stompserver &', then run 'ruby lib/main.rb'

That's it - you should see the 'app run, and the ping and pong workers
do their thing - over Stomp.

I've include the ruby stompserver as a gem dependency in the
ping-pong-engine project, so it was fetch with the 'bundle' command.
