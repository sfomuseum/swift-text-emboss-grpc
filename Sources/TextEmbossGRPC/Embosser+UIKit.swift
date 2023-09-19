#if os(iOS) || os(tvOS)
import UIKit
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension TextEmbosser {
    
    func loadImage(url: URL) throws -> CGImage? {
        
        var im: UIImage
        
        do {
            let im_data = try Data(contentsOf: url)
            im =  UIImage(data: im_data)
        } catch {
            throw(Errors.invalidImage)
        }
        
        return im.ciImage
    }
}

#endif
