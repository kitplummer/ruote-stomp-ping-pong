This is a port of the ruote-amqp-ping-pong investigation:

https://github.com/coffeeaddict/ruote-amqp-ping-pong

but using Stomp instead of AMQP.  I'm also referencing my git fork of
Daemon-Kit which has the ruote_stomp functionality in it.  The example
engine app, references my ruote-stomp library (via git)

== Demonstration

1. Clone this project.


2. Open 3 terminal windows and cd into each project subdirectory [ping/, pong/,
ping-pong-engine/].

3. Ping

```sh
➜  ping bundle
➜  ping bin/ping
```

4. Pong

```sh
➜  pong bundle
➜  pong bin/pong
```

5. Ping-Pong-Engine

```sh
➜  ping-pong-engine bundle
➜  ping-pong-engine stompserver &
➜  ping-pong-engine ruby lib/main.rb
```

That's it - you should see the 'app run, and the ping and pong workers
do their thing - over Stomp.

I've include the ruby stompserver as a gem dependency in the
ping-pong-engine project, so it was fetch with the 'bundle' command.
