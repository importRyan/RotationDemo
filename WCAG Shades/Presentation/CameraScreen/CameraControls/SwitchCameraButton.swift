//  © 2021 Ryan Ferrell. github.com/importRyan

import UIKit

final class SwitchCameraButton: BlackImageButton {
    
    private weak var camera: CameraController?
    
    init(_ camera: CameraController?) {
        self.camera = camera
        super.init()
        addTarget(self, action: #selector(switchOnTap), for: .touchUpInside)
        setImage(UIImage(systemName: Symbols.switchCamera), for: .normal)
        accessibilityLabel = "Switch Camera"
        accessibilityTraits = .button
    }
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Intents

extension SwitchCameraButton {
    
    @objc func switchOnTap() {
        camera?.switchCameraInput {
            UIView.animate(withDuration: 0.5) {
                self.transform = self.transform == .identity
                    ? .init(scaleX: -1, y: 1)
                    : .identity
            }
        }
    }
}
