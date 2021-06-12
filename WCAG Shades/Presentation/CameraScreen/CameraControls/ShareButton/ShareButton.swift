//  © 2021 Ryan Ferrell. github.com/importRyan

import UIKit

final class ShareButton: BlackImageButton {
    
    private weak var camera: CameraController?
    private weak var filter: FilterState?
    
    init(_ camera: CameraController?, _ filter: FilterState) {
        self.camera = camera
        self.filter = filter
        super.init()
        camera?.capturedImageDelegate = self
        addTarget(self, action: #selector(shareTap), for: .touchUpInside)
        setImage(UIImage(systemName: Symbols.share), for: .normal)
        accessibilityLabel = "Share Photo"
        accessibilityTraits = .button
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

// MARK: - Intents

extension ShareButton {
    
    @objc func shareTap() {
        camera?.captureImage()
    }

}

extension ShareButton: CapturedImageDelegate {
    
    func imageDidCapture(_ image: CIImage) {
        DispatchQueue.global(qos: .userInteractive).async {
            let image = UIImage(ciImage: image)
            let share = PhotoProvider(image, visionSim: self.filter?.visionSimulation.value)
            
            DispatchQueue.main.async {
                let vc = UIActivityViewController(activityItems: [share], applicationActivities: nil)
                vc.popoverPresentationController?.sourceView = UIDevice.current.userInterfaceIdiom == .pad ? self : nil
                self.window?.rootViewController?.present(vc, animated: true, completion: nil)
            }
        }
    }
}
