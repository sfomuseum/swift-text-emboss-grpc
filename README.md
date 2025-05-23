# swift-text-emboss-www-grpc

A simple gRPC server wrapping the `sfomuseum/swift-text-emboss` package.

## Background

For background, please see the [Searching Text in Images on the Aviation Collection Website](https://millsfield.sfomuseum.org/blog/2023/09/14/image-text-search/) blog post.

## Example

Building the server.

```
$> swift build
Building for debugging...
[9/9] Emitting module text_emboss_grpc_server
Build complete! (0.76s)

$> ./.build/debug/text-emboss-grpc-server -h
USAGE: text-embosser <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  serve (default)         Starts a image embosser server.

  See 'text-embosser help <subcommand>' for detailed help.
```
  
### serve(r)

```
$> ./.build/debug/text-emboss-grpc-server serve -h
OVERVIEW: Starts a image embosser server.

USAGE: text-embosser serve [--host <host>] [--port <port>] [--logfile <logfile>] [--verbose <verbose>] [--tls_certificate <tls_certificate>] [--tls_key <tls_key>] [--max_receive_message_length <max_receive_message_length>]

OPTIONS:
  --host <host>           The host name to listen for new connections (default: 127.0.0.1)
  --port <port>           The port to listen on (default: 8080)
  --logfile <logfile>     Log events to system log files (default: false)
  --verbose <verbose>     Enable verbose logging (default: false)
  --tls_certificate <tls_certificate>
                          The TLS certificate chain to use for encrypted connections
  --tls_key <tls_key>     The TLS private key to use for encrypted connections
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

* [Sources/Protos/text-embosser/text_embosser.proto](Sources/Protos/text-embosser/text_embosser.proto)

## See also

* https://github.com/sfomuseum/swift-text-emboss
* https://github.com/sfomuseum/swift-text-emboss-cli
* https://github.com/sfomuseum/swift-text-emboss-www
* https://github.com/sfomuseum/go-text-emboss
* https://github.com/sfomuseum/swift-grpc-server
* https://github.com/grpc/grpc-swift
