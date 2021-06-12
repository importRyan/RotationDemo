//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

extension CGPoint {
    
    func relativelyScaledIn(_ rect: CGRect) -> CGPoint {
        .init(x: self.x / rect.width, y: self.y / rect.height)
    }
}
