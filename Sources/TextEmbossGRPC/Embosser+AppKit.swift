#if os(macOS)
import AppKit
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension TextEmbosser {
    
    func loadImage(url: URL) throws -> CGImage? {
        
        guard let im = NSImage(byReferencingFile:url.path) else {
            throw(Errors.invalidImage)
        }
                        
        guard let cgImage = im.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw(Errors.cgImage)
        }
        
        return cgImage
    }
}
#endif
