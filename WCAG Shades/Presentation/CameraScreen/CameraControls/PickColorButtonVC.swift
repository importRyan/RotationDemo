import UIKit
import Combine

final class PickColorButtonVC: UIViewController  {
    
    lazy var button: FlowerButton = .init(
        frame: .init(origin: view.frame.origin,
                     size: .init(square: overrideSize ?? .colorButtonDiameter)),
        userColor: filter.comparatorColor
    )
    
    private lazy var picker = makeUIColorPickerVC()
    private unowned let filter: FilterState

    private var overrideSize: CGFloat?
    
    init(filter: FilterState, overrideSize: CGFloat? = nil) {
        self.filter = filter
        self.overrideSize = overrideSize
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

// MARK: - Intents

extension PickColorButtonVC {
    
    @objc func tapped() {
        impactLight.prepare()
        picker.popoverPresentationController?.sourceView = UIDevice.current.userInterfaceIdiom == .pad ? self.view : nil
        present(picker, animated: true)
        impactLight.impactOccurred()
    }
    
    func makeUIColorPickerVC() -> UIColorPickerViewController {
        let vc = UIColorPickerViewController()
        vc.supportsAlpha = false
        vc.selectedColor = filter.comparatorColor.value
        return vc
    }
}

extension PickColorButtonVC: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ vc: UIColorPickerViewController) {
        filter.comparatorColor.send(vc.selectedColor)
    }
    
    func colorPickerViewControllerDidSelectColor(_ vc: UIColorPickerViewController) {
        filter.comparatorColor.send(vc.selectedColor)
    }
}

// MARK: - Setup

extension PickColorButtonVC {
    
    override func viewDidLoad() {
        setup()
    }
    
    private func setup() {
        picker.delegate = self
        picker.supportsAlpha = false
        picker.title = "WCAG Contrast Color"
        button.accessibilityLabel = "Choose Color"
        picker.modalPresentationStyle = .popover
        
        button.alpha = 0.95
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        button.startAnimatingPressActions()

        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        if overrideSize != nil {
            button.pinToBounds(view)
        } else {
            view.constrain(button) {[
                button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                button.widthAnchor.constraint(equalToConstant: .colorButtonDiameter),
                button.heightAnchor.constraint(equalToConstant: .colorButtonDiameter),
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            ]}
        }
    }
    
}
