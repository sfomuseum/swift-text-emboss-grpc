#if os(iOS) || os(tvOS)
import UIKit
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension TextEmbosser {
    
    func loadImage(url: URL) -> Result<CGImage, Error> {
                
        let im_data = try Data(contentsOf: url)
        
        guard let im =  UIImage(data: im_data) else {
            return .failure(Errors.invalidImage)
        }
        
        return .success(im.ciImage)
    }
}

#endif
