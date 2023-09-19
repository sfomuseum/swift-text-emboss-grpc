import ArgumentParser
import Logging
import TextEmbossGRPC

@available(macOS 10.15, *)
@main
struct TextEmbossServer: AsyncParsableCommand {
    
    @Option(help: "The host name to listen for new connections")
    var host = "localhost"
    
    @Option(help: "The port to listen on for new connections")
    var port = 1234

  func run() async throws {

      let logger = Logger(label: "org.sfomuseum.text-emboss-grpc-server")
      let threads = 1
      
      let s = TextEmbossGRPC.GRPCServer(logger: logger, threads: threads)
      try await s.Run(host: host, port: port)

  }
}
