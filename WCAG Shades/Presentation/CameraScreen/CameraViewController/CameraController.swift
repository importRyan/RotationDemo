//  © 2021 Ryan Ferrell. github.com/importRyan

import UIKit

protocol CameraController: UIViewController {
    
    var capturedImageDelegate: CapturedImageDelegate? { get set }
    func captureImage()
    
    var exposureDelegate: ExposureDelegate? { get set }
    var exposureBiasLimits: (min: Float, max: Float) { get }
    func setExposure(_ ev: Float)
    /// Relative position 0...1
    func autoExpose(at point: CGPoint)
    
    func switchCameraInput(completion: @escaping () -> Void)
    func start()
    func pause()
}

protocol CapturedImageDelegate: AnyObject {
    
    func imageDidCapture(_ image: CIImage)
}

protocol ExposureDelegate: AnyObject {
    
    func updateExposureLimits(min: Float, max: Float)
    func updateExposureBias(bias: CGFloat)
}
