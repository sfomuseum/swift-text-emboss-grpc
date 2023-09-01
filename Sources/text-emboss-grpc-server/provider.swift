import GRPC
import NIOCore
import Foundation
import AppKit
import TextEmboss

@available(macOS 10.15, *)
final class TextEmbossProvider: EmbosserAsyncProvider {
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
                print(error)
            }
        }
         
        guard let im = NSImage(byReferencingFile:temporaryFileURL.path) else {
            throw(Errors.invalidImage)
        }
         
        guard let cgImage = im.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw(Errors.cgImage)
        }
         
        let te = TextEmboss()
        let rsp = te.ProcessImage(image: cgImage)
         
         switch rsp {
         case .failure(let error):
             throw(error)
         case .success(let txt):
             
             return EmbossTextResponse.with{
                 $0.filename = request.filename
                 $0.body = txt
             }
             
         }
         
    }
    



}
