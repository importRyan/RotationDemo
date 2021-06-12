//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit
import Combine

extension UIDevice {
    
    /// Workaround for willTransitionTo not respecting child VC
    func getRotationFromPortrait() -> AnyPublisher<CGAffineTransform, Never> {
        NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .handleEvents { _ in
                UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            } receiveCancel: {
                UIDevice.current.endGeneratingDeviceOrientationNotifications()
            }
            .map { _ in UIDevice.current.orientation }
            .filter { orientation in ![.faceUp, .faceDown].contains(where: { $0 == orientation }) }
            .map { orientation -> CGFloat in
                switch orientation {
                    case .faceDown: return 0
                    case .faceUp: return 0
                    case .landscapeLeft: return .pi / 2
                    case .landscapeRight: return -.pi / 2
                    case .portrait: return 0
                    case .portraitUpsideDown: return .pi
                    default: return 0
                }
            }
            .map { CGAffineTransform(rotationAngle: $0) }
            .eraseToAnyPublisher()
        
    }
    
    /// Workaround for willTransitionTo not respecting child VC
    func getOrientation() -> AnyPublisher<UIDeviceOrientation, Never> {
        NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .handleEvents { _ in
                UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            } receiveCancel: {
                UIDevice.current.endGeneratingDeviceOrientationNotifications()
            }
            .map { _ in UIDevice.current.orientation }
            .filter { orientation in ![.faceUp, .faceDown].contains(where: { $0 == orientation }) }
            .eraseToAnyPublisher()
        
    }
}
