//  © 2021 Ryan Ferrell. github.com/importRyan

import UIKit

final class CameraControlsVC: UIViewController {
    
    private let exposureSlider: ExposureSlider
    private let share: ShareButton
    private let metric: WCAGMetricButton
    private let color: PickColorButtonVC
    private let switchCam: SwitchCameraButton
    private let vision: VisionSimulationButton
    private let exposeTap: ExposureTapVC
    
    private weak var camera: CameraController?
    
    init(camera: CameraController?, filter: FilterState) {
        self.camera = camera
        self.exposureSlider = ExposureSlider(camera: camera, frame: .zero)
        self.share = ShareButton(camera, filter)
        self.metric = WCAGMetricButton(filter: filter)
        self.color = PickColorButtonVC(filter: filter)
        self.switchCam = SwitchCameraButton(camera)
        self.vision = VisionSimulationButton(filter: filter)
        self.exposeTap = ExposureTapVC(camera)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private lazy var constraintsPortrait = makePortraitConstraints()
    private lazy var constraintsLandscape = makeLandscapeConstraints()
}

// MARK: - Setup

extension CameraControlsVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        addChild(exposeTap)
        exposeTap.didMove(toParent: self)
        view.addSubview(exposeTap.view)
        
        addChild(color)
        color.didMove(toParent: self)
        view.addSubview(color.view)
        
        view.addSubview(metric)
        view.addSubview(share)
        view.addSubview(switchCam)
        view.addSubview(exposureSlider)
        view.addSubview(vision)
        
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.activate(constraintsLandscape)
            exposureSlider.transform = CGAffineTransform(rotationAngle: -.pi / 2)
            
        } else {
            NSLayoutConstraint.activate(constraintsPortrait)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if size.isPortrait {
            NSLayoutConstraint.deactivate(constraintsLandscape)
            NSLayoutConstraint.activate(constraintsPortrait)
            exposureSlider.transform = .identity
            
        } else {
            NSLayoutConstraint.deactivate(constraintsPortrait)
            NSLayoutConstraint.activate(constraintsLandscape)
            exposureSlider.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        }
    }
}

extension CameraControlsVC {
 
    func makePortraitConstraints() -> [NSLayoutConstraint] {
        let (optionButtonWidth, optionButtonHeight) = (CGFloat(70), CGFloat(45))
        let optionButtonHorizontalPadding = CGFloat(28)
        let bottomOffset = CGFloat(-50)
        let colorRowHeightOffset = CGFloat(-15)
        
        return .pinning(exposeTap.view, to: view) + [
            
            color.view.widthAnchor.constraint(equalToConstant: .colorButtonDiameter),
            color.view.heightAnchor.constraint(equalToConstant: .colorButtonDiameter),
            color.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            color.view.bottomAnchor.constraint(equalTo: exposureSlider.topAnchor, constant: colorRowHeightOffset),
            
            share.widthAnchor.constraint(equalToConstant: UIFontMetrics.default.scaledValue(for: optionButtonWidth)),
            share.heightAnchor.constraint(equalToConstant: UIFontMetrics.default.scaledValue(for: optionButtonHeight)),
            share.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: optionButtonHorizontalPadding),
            share.centerYAnchor.constraint(equalTo: color.view.centerYAnchor),
            
            metric.widthAnchor.constraint(equalToConstant: UIFontMetrics.default.scaledValue(for: optionButtonWidth)),
            metric.heightAnchor.constraint(equalToConstant: UIFontMetrics.default.scaledValue(for: optionButtonHeight)),
            metric.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -optionButtonHorizontalPadding),
            metric.centerYAnchor.constraint(equalTo: color.view.centerYAnchor),
            
            exposureSlider.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            exposureSlider.leadingAnchor.constraint(equalTo: switchCam.trailingAnchor, constant: optionButtonHorizontalPadding / 2),
            exposureSlider.trailingAnchor.constraint(equalTo: vision.leadingAnchor, constant: -optionButtonHorizontalPadding / 2),
            exposureSlider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomOffset),
            
            switchCam.widthAnchor.constraint(equalToConstant: UIFontMetrics.default.scaledValue(for: optionButtonWidth)),
            switchCam.heightAnchor.constraint(equalToConstant: UIFontMetrics.default.scaledValue(for: optionButtonHeight)),
            switchCam.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: optionButtonHorizontalPadding),
            switchCam.centerYAnchor.constraint(equalTo: exposureSlider.centerYAnchor),
            
            vision.widthAnchor.constraint(equalToConstant: UIFontMetrics.default.scaledValue(for: optionButtonWidth)),
            vision.heightAnchor.constraint(equalToConstant: UIFontMetrics.default.scaledValue(for: optionButtonHeight)),
            vision.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -optionButtonHorizontalPadding),
            vision.centerYAnchor.constraint(equalTo: exposureSlider.centerYAnchor),
        ]
    }
    
    func makeLandscapeConstraints() -> [NSLayoutConstraint] {
        let (optionButtonWidth, optionButtonHeight) = (CGFloat(70), CGFloat(45))
        let optionButtonHorizontalPadding = CGFloat(28)
        let trailingOffset = CGFloat(-15)
        let colorRowHeightOffset = CGFloat(-15)
        
        return .pinning(exposeTap.view, to: view) + [
           
            metric.widthAnchor.constraint(equalToConstant: UIFontMetrics.default.scaledValue(for: optionButtonWidth)),
            metric.heightAnchor.constraint(equalToConstant: UIFontMetrics.default.scaledValue(for: optionButtonHeight)),
            metric.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: optionButtonHorizontalPadding),
            metric.centerXAnchor.constraint(equalTo: color.view.centerXAnchor),
            
            color.view.widthAnchor.constraint(equalToConstant: .colorButtonDiameter),
            color.view.heightAnchor.constraint(equalToConstant: .colorButtonDiameter),
            color.view.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            color.view.trailingAnchor.constraint(equalTo: vision.leadingAnchor, constant: colorRowHeightOffset),
            
            share.widthAnchor.constraint(equalToConstant: UIFontMetrics.default.scaledValue(for: optionButtonWidth)),
            share.heightAnchor.constraint(equalToConstant: UIFontMetrics.default.scaledValue(for: optionButtonHeight)),
            share.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -optionButtonHorizontalPadding),
            share.centerXAnchor.constraint(equalTo: color.view.centerXAnchor),
            
          
            switchCam.widthAnchor.constraint(equalToConstant: UIFontMetrics.default.scaledValue(for: optionButtonWidth)),
            switchCam.heightAnchor.constraint(equalToConstant: UIFontMetrics.default.scaledValue(for: optionButtonHeight)),
            switchCam.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -optionButtonHorizontalPadding),
            switchCam.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: trailingOffset),
            
            exposureSlider.heightAnchor.constraint(equalToConstant: 60),
            exposureSlider.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: (-optionButtonHeight * 2) - (optionButtonHorizontalPadding * 5)),
            exposureSlider.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            exposureSlider.centerXAnchor.constraint(equalTo: vision.centerXAnchor),
            
            vision.widthAnchor.constraint(equalToConstant: UIFontMetrics.default.scaledValue(for: optionButtonWidth)),
            vision.heightAnchor.constraint(equalToConstant: UIFontMetrics.default.scaledValue(for: optionButtonHeight)),
            vision.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: optionButtonHorizontalPadding),
            vision.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: trailingOffset),
        ]
    }
}
