import GRPC
import NIOCore

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
final class TextEmbossProvider: EmbosserAsyncProvider {
  let interceptors: EmbosserServerInterceptorFactoryProtocol? = nil
        
    func embossText(request: EmbossTextRequest, context: GRPC.GRPCAsyncServerCallContext) async throws -> EmbossTextResponse {
    
        /*
         
         let uuid = UUID().uuidString
         let fname = uuid + ext
         
         let data: NSData = myFileMultipart.body.withUnsafeBufferPointer { pointer in
             return NSData(bytes: pointer.baseAddress, length: myFileMultipart.body.count)
         }
         
         guard let fileSaveUrl = NSURL(string: fname, relativeTo: documentsUrl) else {
             logger.error("Failed to derive file save URL")
             return .internalServerError
         }
         
         guard data.write(to: fileSaveUrl as URL, atomically: true) else {
             logger.error("Failed to write image data")
             return .internalServerError
         }
         
         defer {
             do {
                 try FileManager.default.removeItem(at: fileSaveUrl as URL)
             } catch {
                 logger.error("Failed to remove \(fileSaveUrl.path!), \(error)")
             }
         }
         
         guard let im = NSImage(byReferencingFile:fileSaveUrl.path!) else {
             logger.error("Invalid image")
             return .badRequest(.text("Invalid image"))
         }
         
         guard let cgImage = im.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
             logger.error("Failed to derive CG image")
             return .internalServerError
         }
         
         let te = TextEmboss()
         let rsp = te.ProcessImage(image: cgImage)
         
         switch rsp {
         case .failure(let error):
             logger.error("Failed to process image, \(error)")
             return .internalServerError
         case .success(let txt):
             return .ok(.text(txt))
         }
         
         */
        
        return EmbossTextResponse.with{
            $0.filename = request.filename
            $0.body = ""
        }
    }
    



}
