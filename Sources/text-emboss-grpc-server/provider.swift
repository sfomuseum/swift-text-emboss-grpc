import GRPC
import NIOCore

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
final class TextEmbossProvider: EmbosserAsyncClientProtocol {
    var channel: GRPC.GRPCChannel
    
    var defaultCallOptions: GRPC.CallOptions
    
  // let interceptors: Helloworld_GreeterServerInterceptorFactoryProtocol? = nil

  func EmbossText(
    request: EmbossTextRequest,
    context: GRPCAsyncServerCallContext
  ) async throws -> EmbossTextResponse {
      /*
    let recipient = request.name.isEmpty ? "stranger" : request.name
    return Helloworld_HelloReply.with {
      $0.message = "Hello \(recipient)!"
    }
       */
  }
}
