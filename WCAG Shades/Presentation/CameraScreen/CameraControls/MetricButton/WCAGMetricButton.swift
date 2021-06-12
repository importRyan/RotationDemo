import UIKit

final class WCAGMetricButton: BlackImageButton {
    
    weak var filter: FilterState?
    
    init(filter: FilterState?) {
        self.filter = filter
        super.init()
        configureButtonContents()
        configureMenu()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

// MARK: - Popped Menu

private extension WCAGMetricButton {
    
    func configureMenu() {
        isEnabled = true
        isUserInteractionEnabled = true
        isPointerInteractionEnabled = true
        showsMenuAsPrimaryAction = true
        menu = makeMenu()
    }
    
    func makeMenu() -> UIMenu {
        UIMenu(title: "WCAG Contrast Threshold",
               image: UIImage(systemName: Symbols.contrast),
               options: .displayInline,
               children: makeMenuChildren())
    }
    
    func makeMenuChildren() -> [UIMenuElement] {
        
        let off = UIAction(
            title: WCAGThreshold.off.label,
            image: WCAGThreshold.off.menuImage,
            state: filter?.thresholdWCAG == WCAGThreshold.off ? .on : .off
        ) { [weak self] _ in
            
            guard let self = self else { return }
            self.filter?.setThreshold(WCAGThreshold.off)
            self.setImage(WCAGThreshold.off.buttonImage, for: .normal)
            self.menu = self.makeMenu() // UIActions immutable, so force rebuild for checkmarks
        }
        
        let submenuOff = UIMenu(title: "", options: .displayInline, children: [off])
        
        let active = WCAGThreshold.activeCases.map { threshold in
            
            UIAction(
                title: threshold.label,
                image: threshold.menuImage,
                state: filter?.thresholdWCAG == threshold ? .on : .off
            ) { [weak self] _ in
                
                guard let self = self else { return }
                self.filter?.setThreshold(threshold)
                self.setImage(threshold.buttonImage, for: .normal)
                self.menu = self.makeMenu() // UIActions immutable, so force rebuild for checkmarks
            }
        }
        
        return [submenuOff] + active
    }
}


// MARK: - Layout Button

private extension WCAGMetricButton {

    func configureButtonContents() {
        accessibilityLabel = "Minimum Contrast Ratio"
        accessibilityTraits = .button
        contentMode = .scaleAspectFit
        adjustsImageSizeForAccessibilityContentSizeCategory = true
        setImage(filter?.thresholdWCAG.buttonImage, for: .normal)
        imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = UIEdgeInsets(vertical: 8, horizontal: 13)
        adjustsImageWhenHighlighted = false
    }
}
