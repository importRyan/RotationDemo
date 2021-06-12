//  © 2021 Ryan Ferrell. github.com/importRyan

import UIKit

extension UIImage {

    internal func imageScaled(toSize scaledSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        let newImage = renderer.image { [unowned self] _ in
            self.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
        return newImage
    }
}
