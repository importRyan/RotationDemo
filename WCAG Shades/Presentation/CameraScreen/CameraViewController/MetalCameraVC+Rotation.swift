//  © 2021 Ryan Ferrell. github.com/importRyan

import UIKit
import AVKit

// MARK: - Apply counter-transform during transition

extension MetalCameraVC {
    
    /// Apple Technical QA 1890 Prevent View From Rotating
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mtkView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }

    /// Apple Technical QA 1890 Prevent View From Rotating
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate { [self] context in

            let delta = coordinator.targetTransform
            let deltaAngle = atan2(delta.b, delta.a)
            var currentAngle = mtkView.layer.value(forKeyPath: "transform.rotation.z") as? CGFloat ?? 0
            currentAngle += -1 * deltaAngle + 0.1
            mtkView.layer.setValue(currentAngle, forKeyPath: "transform.rotation.z")

        } completion: { [self] context in

            var rounded = mtkView.transform
            rounded.a = round(rounded.a)
            rounded.b = round(rounded.b)
            rounded.c = round(rounded.c)
            rounded.d = round(rounded.d)
            mtkView.transform = rounded
        }
    }
    
}


// MARK: - Setup constraints. This is perhaps where my problem is. There is also a scale applied to the Drawable so it fills the screen (MetalCameraVC.swift line 80)

extension MetalCameraVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(mtkView)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mtkView.frame = view.frame
        if let orientation = AVCaptureVideoOrientation.fromCurrentDeviceOrientation() {
            lastOrientation = orientation
        }
    }
    
    /// Expects that prior VCs handled permissions so that MTKView can be built unstopped
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMetal()
        DispatchQueue.global(qos: .userInitiated).async {
            self.setupAVCaptureSession()
            self.monitorSceneChanges()
        }
        view.backgroundColor = .white // For camera "take picture flash"
    }

}
