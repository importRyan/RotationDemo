//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

extension CGRect {
    
    func zeroOrigin() -> Self {
        CGRect(origin: .zero, size: size)
    }
}

extension CGSize {
    
    func zeroOriginRect() -> CGRect {
        CGRect(origin: .zero, size: self)
    }
}
