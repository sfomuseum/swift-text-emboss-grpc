#if os(iOS) || os(tvOS)
import UIKit
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension TextEmbosser {
    
    func loadImage(url: URL) throws -> CGImage? {
        
        var im: UIImage
        
        do {
            let data = try Data(contentsOf: url)
            im =  UIImage(data: imageData)
        } catch {
            throw(Errors.invalidImage)
        }
        
        guard let cgImage = im.cgImage() else {
            throw(Errors.cgImage)
        }
        
        return cgImage
    }
}

#endif
