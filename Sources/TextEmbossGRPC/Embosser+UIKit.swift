#if os(iOS) || os(tvOS)
import UIKit
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension TextEmbosser {
    
    func loadImage(url: URL) throws -> CGImage? {
                
        let im_data = try Data(contentsOf: url)
        
        guard let im =  UIImage(data: im_data) else {
            throw(Errors.invalidImage)
        }
        
        return im.ciImage?
    }
}

#endif
