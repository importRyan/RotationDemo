//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

class CloseButton: UIButton {
    
    init(tint: UIColor) {
        super.init(frame: .zero)
        configure(tint: tint)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(tint: UIColor) {
        let image = UIImage(systemName: Symbols.close)?.applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(textStyle: .title1))
        setImage(image, for: .normal)
        tintColor = tint
        imageView?.tintColor = tint
    }
}
