#if os(macOS)
import AppKit
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension TextEmbosser {
    
    func loadImage(url: URL) -> Result<CGImage, Error> {
        
        guard let im = NSImage(byReferencingFile:url.path) else {
            return .failure(Errors.invalidImage)
        }
                        
        guard let cgImage = im.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return .failure(Errors.cgImage)
        }
        
        return .success(cgImage)
    }
}
#endif
