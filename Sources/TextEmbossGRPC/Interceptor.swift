import Foundation
import GRPC

// This is used in conjunction with GRPCServerLogger to append the remote address
// associated with the request to metadata in log messages.

final class TextEmbosserServerInterceptorFactory: EmbosserServerInterceptorFactoryProtocol {
    
    func makeEmbossTextInterceptors() -> [GRPC.ServerInterceptor<EmbossTextRequest, EmbossTextResponse>] {
        return [TextEmbosserServerInterceptor()]
    }
}

final class TextEmbosserServerInterceptor: ServerInterceptor<EmbossTextRequest, EmbossTextResponse> {
    
    override func receive(
      _ part: GRPCServerRequestPart<EmbossTextRequest>,
      context: ServerInterceptorContext<EmbossTextRequest, EmbossTextResponse>
    ) {
        
        switch part {
        case .metadata(var m):
            if context.remoteAddress != nil {
                m.add(name: "remoteAddress", value: context.remoteAddress!.description)
            }
            context.receive(.metadata(m))
        default:
            context.receive(part)
        }
    }
}
