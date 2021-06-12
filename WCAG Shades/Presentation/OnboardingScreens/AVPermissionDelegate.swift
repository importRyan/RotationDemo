//  © 2021 Ryan Ferrell. github.com/importRyan

import Combine
import UIKit
import AVFoundation

protocol AVPermissionsDelegate: AnyObject {
    
    func cameraPermissionsDenied()
    func cameraPermissionsAccepted()
}

extension AVPermissionsDelegate {
    
    func askForAVPermissions() {
        
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
            case .authorized:
                DispatchQueue.main.async { [weak self] in
                    self?.cameraPermissionsAccepted()
                }
                
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] authorized in
                    
                    DispatchQueue.main.async { [weak self] in
                        if !authorized { self?.cameraPermissionsDenied() }
                        if authorized { self?.cameraPermissionsAccepted() }
                    }
                }
            default:
                DispatchQueue.main.async { [weak self] in
                    self?.cameraPermissionsDenied()
                }
        }
    }
    
    func notifyPermissionsStateChangeOnReopen() -> AnyCancellable {
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.askForAVPermissions()
            }
    }
}
