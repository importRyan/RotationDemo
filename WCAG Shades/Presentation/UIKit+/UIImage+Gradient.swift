//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        
        
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    static func imageWithGradient(from beginColor: UIColor,
                                  to endColor: UIColor,
                                  with size: CGSize = CGSize(width: 100, height: 100)
    ) -> UIImage {
        let layer = CAGradientLayer()
        layer.frame = CGRect(origin: .zero, size: size)
        layer.colors = [beginColor.cgColor, endColor.cgColor]
        layer.startPoint = CGPoint.zero
        layer.endPoint = CGPoint(x: 1, y: 1)
        UIGraphicsBeginImageContext(size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
