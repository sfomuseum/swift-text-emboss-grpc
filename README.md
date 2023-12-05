# swift-text-emboss-www-grpc

A simple gRPC server wrapping the `sfomuseum/swift-text-emboss` package.

## Example

Building the server.

```
$> swift build
Building for debugging...
[9/9] Emitting module text_emboss_grpc_server
Build complete! (0.76s)
```

Server start-up options.

```
$> ./.build/debug/text-emboss-grpc-server -h
USAGE: text-emboss-server [--host <host>] [--port <port>] [--threads <threads>] [--logfile <logfile>] [--verbose <verbose>] [--tls_certificate <tls_certificate>] [--tls_key <tls_key>] [--max_receive_message_length <max_receive_message_length>]

OPTIONS:
  --host <host>           The host name to listen for new connections (default: localhost)
  --port <port>           The port to listen on for new connections (default: 8080)
  --threads <threads>     The number of threads to use for the GRPC server (default: 1)
  --logfile <logfile>     Log events to system log files (default: false)
  --verbose <verbose>     Enable verbose logging (default: false)
  --tls_certificate <tls_certificate>
                          The path to a TLS certificate to use for secure connections (optional)
  --tls_key <tls_key>     The path to a TLS key to use for secure connections (optional)
  --max_receive_message_length <max_receive_message_length>
                          Sets the maximum message size in bytes the server may receive. If 0 then the swift-grpc defaults will be used. (default: 0)
  -h, --help              Show help information.
```

Running the server.

```
$> .build/debug/text-emboss-grpc-server
2023-10-23T15:24:41.391-07:00 347180 [INFO] ["label": "org.sfomuseum.text-emboss-grpc-server", "source": "GRPCServer", "metadata": ""] GRPCServer/Server.swift#L.47 Run(_:) server started on port 8080
```

And then (given [this image](https://github.com/sfomuseum/go-text-emboss/blob/main/fixtures/menu.jpg) running [this client](https://github.com/sfomuseum/go-text-emboss#remote-grpc)):

```
$> go run cmd/emboss/main.go -embosser-uri 'grpc://localhost:8080' ./fixtures/menu.jpg
Mood-lit Libations
Champagne Powder Cocktail
Champagne served with St. Germain
elderflower liqueur and hibiscus syrup
Mile-High Manhattan
Stranahans whiskey served with
sweet vermouth
Peach Collins On The Rockies
Silver Tree vodka, Leopold Bros peach
liqueur, lemon juice and agave nectar
Colorado Craft Beer
California Wines
"america
```

## Definitions

### embosser.proto

* [Sources/text-emboss-grpc-server/embosser.proto](Sources/text-emboss-grpc-server/embosser.proto)

## Known-knowns

### Logging

Under the hood this package uses the [Puppy](https://github.com/sushichop/Puppy) library for logging to both the console and a rotating log file. There is an open ticket to (hopefully) address a problem where messages are only dispatched to the first logger. In this instance that means messages are dispatched to an optional log file and then the console meaning if you specify a `--log_file` flag logging message _will not_ be dispatched to the console.

* https://github.com/sushichop/Puppy/issues/89

## See also

* https://github.com/sfomuseum/swift-text-emboss
* https://github.com/sfomuseum/swift-text-emboss-cli
* https://github.com/sfomuseum/swift-text-emboss-www
* https://github.com/sfomuseum/go-text-emboss
* https://github.com/sfomuseum/swift-grpc-server
* https://github.com/grpc/grpc-swift
