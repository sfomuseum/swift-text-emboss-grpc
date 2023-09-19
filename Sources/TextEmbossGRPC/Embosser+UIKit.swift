#if os(iOS) || os(tvOS)
import UIKit
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension TextEmbosser {
    
    func loadImage(url: URL) -> Result<CGImage, Error> {
                
        var im_data: Data
        
        do {
            im_data = try Data(contentsOf: url)
        } catch (let error){
            return .failure(error)
        }
        
        guard let im =  UIImage(data: im_data) else {
            return .failure(Errors.invalidImage)
        }
        
        guard let cgImage = im.cgImage else {
            return .failure(Errors.cgImage)
        }
        return .success(cgImage)
    }
}

#endif
