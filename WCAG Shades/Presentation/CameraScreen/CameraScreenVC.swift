//  © 2021 Ryan Ferrell. github.com/importRyan

import UIKit

final class CameraScreenVC: UIViewController {
    
    init(filter: FilterState) {
        self.camera = MetalCameraVC(filter)
        self.controls = CameraControlsVC(camera: camera, filter: filter)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private let camera: CameraController
    private let controls: CameraControlsVC
}

extension CameraScreenVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(camera)
        camera.didMove(toParent: self)
        view.addSubview(camera.view)
        camera.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(controls)
        controls.didMove(toParent: self)
        view.addSubview(controls.view)
        controls.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLayoutConstraint.activate(.pinning(camera.view, to: view))
        if UIDevice.current.userInterfaceIdiom == .pad {
            activatePadConstraints()
        } else { NSLayoutConstraint.activate(.pinning(controls.view, to: view)) }
    }
    
    private func activatePadConstraints() {
        NSLayoutConstraint.activate([
            controls.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            controls.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            controls.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            controls.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45),
        ])
    }
}
