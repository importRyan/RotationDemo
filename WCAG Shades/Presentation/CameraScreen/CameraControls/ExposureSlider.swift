//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

final class ExposureSlider: UISlider {
    
    weak var camera: CameraController?

    init(camera: CameraController?, frame: CGRect) {
        self.camera = camera
        super.init(frame: frame)
        camera?.exposureDelegate = self
        setup()
    }
    
    deinit { camera?.exposureDelegate = nil }
    
    required init?(coder: NSCoder) { fatalError() }
}

// MARK: - Intents

private extension ExposureSlider {
    
    @objc func sliderValueDidChange(_ sender: UISlider) {
        camera?.setExposure(sender.value)
        accessibilityValue = String(format: "%1.1f", sender.value, "EV")
    }
    
    @objc func sliderBeganEdits(_ sender: UISlider) {
        setTrack(visible: true)
    }
    
    @objc func sliderEndedEdits(_ sender: UISlider) {
       setTrack(visible: false)
    }
    
    @objc func doubleTapReset(_ sender: UISlider) {
        sender.cancelTracking(with: nil)
        self.setValue(0, animated: true)
        self.sliderValueDidChange(sender)
        setTrack(visible: false)
    }
    
    func setTrack(visible: Bool) {
        let tint = visible ? Colors.ExposureSliderLabel.ui : UIColor.clear
        let image = Image.ExposureTicks.ui.withTintColor(tint)
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.setMinimumTrackImage(image, for: [.normal])
            self?.setMaximumTrackImage(image, for: [.normal])
            self?.tintColor = tint
            self?.alpha = visible ? 1 : 0.7
        }
    }
}

// MARK: - Setup

extension ExposureSlider: ExposureDelegate {
    
    func updateExposureBias(bias: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            self?.setValue(Float(bias), animated: true)
            self?.accessibilityValue = String(format: "%1.1f", bias, "EV")
        }
    }
    
    func updateExposureLimits(min: Float, max: Float) {
        minimumValue = min * 0.5
        maximumValue = max * 0.5
        accessibilityValue = String(format: "%1.1f", value, "EV")
    }
}

extension ExposureSlider {
    
    private func setup() {
        accessibilityLabel = "Camera Exposure"
        accessibilityValue = String(format: "%1.1f", value, "EV")
        
        value = 0
        isContinuous = true
        minimumValue = -3
        maximumValue = 3
        
        setThumbImage(Image.ExposureKnob.ui, for: .normal)
        
        setTrack(visible: false)
        
        addTarget(self, action: #selector(doubleTapReset(_:)),
                  for: [.touchDownRepeat])
        
        addTarget(self, action: #selector(sliderValueDidChange(_:)),
                  for: .valueChanged)
        
        addTarget(self, action: #selector(sliderBeganEdits(_:)),
                  for: [.touchDragInside, .touchDragOutside])
        
        addTarget(self, action: #selector(sliderEndedEdits(_:)),
                  for: [.touchUpInside, .touchUpOutside])

    }
}
