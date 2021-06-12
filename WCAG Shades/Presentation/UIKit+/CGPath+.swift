//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

extension CGPath {
    
    static func circle(in frame: CGRect) -> CGPath {
        CGPath(ellipseIn: frame, transform: nil)
    }
}
