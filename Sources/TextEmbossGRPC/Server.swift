import Logging
import GRPC
import NIOCore
import NIOPosix
import Logging

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public class GRPCServer {
    
    public var logger: Logger
    
    public var threads: Int = 1    
    var port: Int = 1234
    
    public init(logger: Logger, threads: Int) {
        self.threads = threads
        self.logger = logger
        // self.port = port
    }
    
    public func Run(port: Int) async throws {
        
        self.port = port
        
      let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        
      defer {
        try! group.syncShutdownGracefully()
      }

      // Start the server and print its address once it has started.
      let server = try await Server.insecure(group: group)
            .withServiceProviders([TextEmbosser()])
        .bind(host: "localhost", port: self.port)
        .get()

        self.logger.info("server started on port \(server.channel.localAddress!.port!)")

      // Wait on the server's `onClose` future to stop the program from exiting.
      try await server.onClose.get()
    }
}
