# swift-text-emboss-www-grpc

A simple gRPC server wrapping the `sfomuseum/swift-text-emboss` package.

## Important

This package has only minimal error reporting and validation. It has no authentication or authorization hooks.

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
USAGE: text-emboss-server [--port <port>]

OPTIONS:
  --port <port>           The port to listen on for new connections (default: 1234)
  -h, --help              Show help information.
```

Running the server.

```
$> ./.build/debug/text-emboss-grpc-server 
2023-09-01T11:48:13-0700 info org.sfomuseum.text-emboss-grpc-server : [text_emboss_grpc_server] server started on port 1234
```

And then (given [this image](https://github.com/sfomuseum/go-text-emboss/blob/main/fixtures/menu.jpg) running [this client](https://github.com/sfomuseum/go-text-emboss#remote-grpc)):

```
$> go run cmd/emboss/main.go -embosser-uri 'grpc://localhost:1234' ./fixtures/menu.jpg
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

## See also

* https://github.com/sfomuseum/swift-text-emboss
* https://github.com/sfomuseum/swift-text-emboss-cli
* https://github.com/sfomuseum/swift-text-emboss-www
* https://github.com/sfomuseum/go-text-emboss
* https://github.com/grpc/grpc-swift
