//  © 2021 Ryan Ferrell. github.com/importRyan

import UIKit

class BlackImageButton: UIButton {

    init() {
        super.init(frame: .zero)
        configureButton()
        startAnimatingPressActions()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

// MARK: - Setup

extension BlackImageButton {
    
    func configureButton() {
        backgroundColor = UIColor.black.withAlphaComponent(0.85)
        alpha = 0.88
        clipsToBounds = true
        
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        imageEdgeInsets = .init(top: 0, left: 0, bottom: 1, right: 0)
        
        tintColor = UIColor.white
        adjustsImageWhenHighlighted = true
        adjustsImageSizeForAccessibilityContentSizeCategory = true
        titleLabel?.adjustsFontForContentSizeCategory = true
        setPreferredSymbolConfiguration(.init(pointSize: 16, weight: .bold, scale: .large), forImageIn: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.height / 2
    }
}

extension BlackImageButton {
    
    func restoreBaseColor() {
        tintColor = UIColor.white
        backgroundColor = UIColor.black.withAlphaComponent(0.85)
        alpha = 0.88
    }
}
