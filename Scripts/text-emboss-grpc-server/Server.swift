import ArgumentParser
import SFOMuseumLogger
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
    
    @Option(help: "Log events to system log files")
    var logfile: Bool = false
    
    @Option(help: "Enable verbose logging")
    var verbose = false
    
    @Option(help: "The path to a TLS certificate to use for secure connections (optional)")
    var tls_certificate: String?
    
    @Option(help: "The path to a TLS key to use for secure connections (optional)")
    var tls_key: String?
    
    @Option(help: "Sets the maximum message size in bytes the server may receive. If 0 then the swift-grpc defaults will be used.")
    var max_receive_message_length = 0
    
  func run() async throws {

      let log_label = "org.sfomuseum.text-emboss-grpc-server"
      
      let logger_opts = SFOMuseumLoggerOptions(
          label: log_label,
          console: true,
          logfile: logfile,
          verbose: verbose
      )
      
      let logger = try NewSFOMuseumLogger(logger_opts)

      let embosser = NewTextEmbosser(logger: logger)
      
      let server_opts = GRPCServerOptions(
        host: host,
        port: port,
        threads: threads,
        logger: logger,
        tls_certificate: tls_certificate,
        tls_key: tls_key,
        verbose: verbose,
        max_receive_message_length: max_receive_message_length
      )
      
      let server = GRPCServer(server_opts)
      try await server.Run([embosser])
  }
}
