//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

extension CGPoint {
    init(square: CGFloat) {
        self.init(x: square, y: square)
    }
}

extension CGSize {
    init(square: CGFloat) {
        self.init(width: square, height: square)
    }
}
