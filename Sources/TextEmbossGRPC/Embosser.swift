import GRPC
import NIOCore
import Foundation
import TextEmboss
import Cocoa

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
final class TextEmbosser: EmbosserAsyncProvider {
  let interceptors: EmbosserServerInterceptorFactoryProtocol? = nil
    
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
         
        var cgImage: CGImage
        
        let im_rsp = self.loadImage(url: temporaryFileURL)
        
        switch im_rsp {
        case .failure(let error):
            throw(error)
        case .success(let im):
            cgImage = im
        }

        
        let te = TextEmboss()
        let rsp = te.ProcessImage(image: cgImage)
         
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
