import UIKit

class ImageLoader {
    private static var imageCache: [String: UIImage] = [:]
    
    static func loadImage(url: String, completed: @escaping (UIImage?) -> Void) {
        // TODO
        if let image = imageCache[url] {
            DispatchQueue.main.async {
                completed(image)
            }
            return
        }
        
        guard let imageURL = URL(string: url) else {
            completed(nil)
            return
        }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageURL) {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completed(image)
                }
            } else {
                DispatchQueue.main.async {
                    completed(nil)
                }
            }
        }
        
    }
}
