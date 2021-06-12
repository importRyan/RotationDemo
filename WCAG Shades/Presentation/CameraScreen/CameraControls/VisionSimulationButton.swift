import UIKit

final class VisionSimulationButton: BlackImageButton {
    
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

private extension VisionSimulationButton {
    
    func configureMenu() {
        isEnabled = true
        isUserInteractionEnabled = true
        isPointerInteractionEnabled = true
        showsMenuAsPrimaryAction = true
        menu = makeMenu()
    }
    
    func makeMenu() -> UIMenu {
        UIMenu(title: "Vision Simulation",
               image: UIImage(systemName: Symbols.vision),
               options: .displayInline,
               children: makeMenuChildren())
    }
    
    func makeMenuChildren() -> [UIAction] {
        ColorVision.allCases.map { vision in
            
            UIAction(
                title: vision.name,
                image: nil,
                state: filter?.visionSimulation.value == vision ? .on : .off
            ) { [weak self] _ in
                
                guard let self = self else { return }
                self.filter?.visionSimulation.send(vision)
                self.colorizeButton(for: vision)
                self.menu = self.makeMenu() // UIActions immutable, so force rebuild for checkmarks
            }
        }
    }
}


// MARK: - Layout Button

private extension VisionSimulationButton {

    func configureButtonContents() {
        accessibilityLabel = "Color Vision Simulation"
        accessibilityTraits = .button
        adjustsImageSizeForAccessibilityContentSizeCategory = true
        setImage(UIImage(systemName: Symbols.vision), for: .normal)
        imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true
    }
    
    func colorizeButton(for vision: ColorVision) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            
            guard vision != .typicalTrichromacy else {
                self.restoreBaseColor()
                return
            }
            
            self.tintColor = vision.text
            self.backgroundColor = vision.bg.withAlphaComponent(0.85)
            self.alpha = 0.95
        }
    }
}
