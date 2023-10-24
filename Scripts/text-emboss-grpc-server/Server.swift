import ArgumentParser
import Logging
import TextEmbossGRPC
import GRPCServer

@available(macOS 14.0, *)
@main
struct TextEmbossServer: AsyncParsableCommand {
    
    @Option(help: "The host name to listen for new connections")
    var host = "localhost"
    
    @Option(help: "The port to listen on for new connections")
    var port = 8080

    @Option(help: "The number of threads to use for the GRPC server")
    var threads = 1
    
    @Option(help: "Write logs to specific log file (optional)")
    var log_file: String?
    
    @Option(help: "Enable verbose logging")
    var verbose = false
    
    @Option(help: "The path to a TLS certificate to use for secure connections (optional)")
    var tls_certificate: String?
    
    @Option(help: "The path to a TLS key to use for secure connections (optional)")
    var tls_key: String?
    
  func run() async throws {

      let log_label = "org.sfomuseum.text-emboss-grpc-server"
      let logger = try NewLogger(log_label: log_label, log_file: log_file, verbose: verbose)

      let embosser = NewTextEmbosser(logger: logger)

      let server_opts = GRPCServerOptions(
        host: host,
        port: port,
        threads: threads,
        logger: logger,
        tls_certificate: tls_certificate,
        tls_key: tls_key,
        verbose: verbose
      )
      
      let server = GRPCServer(server_opts)
      try await server.Run([embosser])
  }
}
