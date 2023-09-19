import ArgumentParser
import GRPC
import NIOCore
import NIOPosix
import Logging
import TextEmbossGRPC

@available(macOS 10.15, *)
@main
struct TextEmbossServer: AsyncParsableCommand {
  @Option(help: "The port to listen on for new connections")
  var port = 1234

  func run() async throws {

      let logger = Logger(label: "org.sfomuseum.text-emboss-grpc-server")

    let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
      
    defer {
      try! group.syncShutdownGracefully()
    }

    // Start the server and print its address once it has started.
    let server = try await Server.insecure(group: group)
          .withServiceProviders([TextEmbosser()])
      .bind(host: "localhost", port: self.port)
      .get()

      logger.info("server started on port \(server.channel.localAddress!.port!)")

    // Wait on the server's `onClose` future to stop the program from exiting.
    try await server.onClose.get()
  }
}
