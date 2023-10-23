import GRPC
import NIOCore
import Foundation
import TextEmboss
import CoreGraphics
import CoreGraphicsImage
import Logging
import GRPCServerLogger

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public func NewTextEmbosser(logger: Logger) -> EmbosserAsyncProvider {
    return TextEmbosser(logger: logger)
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
final class TextEmbosser: EmbosserAsyncProvider {
  let interceptors: EmbosserServerInterceptorFactoryProtocol? = nil
    
    let logger: GRPCServerLogger
    
    init(logger: Logger) {
        self.logger = GRPCServerLogger(logger:logger)
        // self.interceptors = ImageEmbosserServerInterceptorFactory()
    }
    
    func embossText(request: EmbossTextRequest, context: GRPC.GRPCAsyncServerCallContext) async throws -> EmbossTextResponse {
        
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(),
                                            isDirectory: true)
        
        let temporaryFilename = ProcessInfo().globallyUniqueString

        let temporaryFileURL =
            temporaryDirectoryURL.appendingPathComponent(temporaryFilename)
        
        try request.body.write(to: temporaryFileURL,
                       options: .atomic)
        
        defer {
            do {
                try FileManager.default.removeItem(at: temporaryFileURL)
            } catch {
                // To do: Use swift-log
                print(error)
            }
        }
         
        var cg_im: CGImage

        let im_rsp = CoreGraphicsImage.LoadFromURL(url: temporaryFileURL)
        
        switch im_rsp {
        case .failure(let error):
            throw(error)
        case .success(let im):
            cg_im = im
        }
        
        let te = TextEmboss()
        let rsp = te.ProcessImage(image: cg_im)
         
         switch rsp {
         case .failure(_):
             throw(Errors.processError)
         case .success(let txt):
             
             return EmbossTextResponse.with{
                 $0.filename = request.filename
                 $0.body = Data(txt.utf8)
             }
             
         }
         
    }
    



}
