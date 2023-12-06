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
    let interceptors: EmbosserServerInterceptorFactoryProtocol?
    let logger: GRPCServerLogger
    
    init(logger: Logger) {
        self.logger = GRPCServerLogger(logger:logger)
        self.interceptors = TextEmbosserServerInterceptorFactory()
    }
    
    func embossText(request: EmbossTextRequest, context: GRPC.GRPCAsyncServerCallContext) async throws -> EmbossTextResponse {
        
        self.logger.setRemoteAddress(context: context)
        
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
                self.logger.error("Failed to remove \(temporaryFileURL), \(error)")
            }
        }
         
        var cg_im: CGImage

        let im_rsp = CoreGraphicsImage.LoadFromURL(url: temporaryFileURL)
        
        switch im_rsp {
        case .failure(let error):
            self.logger.error("Failed to load image from \(temporaryFileURL), \(error)")
            throw(error)
        case .success(let im):
            cg_im = im
        }
        
        let te = TextEmboss()
        let rsp = te.ProcessImage(image: cg_im)
         
         switch rsp {
         case .failure(let error):
             self.logger.error("Failed to process image from \(temporaryFileURL), \(error)")
             throw(Errors.processError)
         case .success(let rsp):
             
             self.logger.info("Processed text from image \(temporaryFileURL)")
             
             return EmbossTextResponse.with{
                 
                 var pb_rsp = EmbossTextResult()
                 pb_rsp.text = rsp.text
                 pb_rsp.source = rsp.source
                 pb_rsp.created = rsp.created
                 
                 $0.filename = request.filename
                 $0.result = pb_rsp
             }
             
         }
         
    }
    



}
