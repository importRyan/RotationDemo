import UIKit
import AVFoundation
import MetalKit
import Combine

final class MetalCameraVC: UIViewController {

    let mtkView = MTKView()
    private(set) var image = CIImage()
    private var scaleToScreenBounds: CGAffineTransform = .identity
    var lastOrientation: AVCaptureVideoOrientation = .landscapeRight
    
    weak var exposureDelegate: ExposureDelegate?
    weak var capturedImageDelegate: CapturedImageDelegate?
    private var captureNextFrame = false
    
    var metalDevice:        MTLDevice!
    var metalCommandQueue:  MTLCommandQueue!
    var ciContext:          CIContext!
    weak var filters:          FilterState?
    
    var session:            AVCaptureSession?
    var videoOutput:        AVCaptureVideoDataOutput?
    var backInput:          AVCaptureInput?
    var backCamera:         AVCaptureDevice?
    var selfieInput:        AVCaptureInput?
    var selfieCamera:       AVCaptureDevice?
    let videoOutputQueue =  DispatchQueue(label: "video", qos: .userInteractive)
    private var isConfiguringCamera = false
    
    private var currentDevice: AVCaptureDevice? {
        session?.inputs.first === self.backInput ? self.backCamera : selfieCamera
    }
    
    private var sceneMonitors = Set<AnyCancellable>()
    
    init(_ filters: FilterState) {
        self.filters = filters
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

// MARK: - Camera feed processing

extension MetalCameraVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let image = CIImage(cvImageBuffer: buffer)
        guard let filtered = filter(image) else { return }
        self.image = filtered
        mtkView.draw()
        
        guard captureNextFrame else { return }
        capturedImageDelegate?.imageDidCapture(filtered)
        captureNextFrame = false
    }
    
    func filter(_ image: CIImage) -> CIImage? {
        filters?.wcag?.setValue(image, forKey: kCIInputImageKey)
        filters?.vision?.setValue(filters?.wcag?.outputImage, forKey: kCIInputImageKey)
        return filters?.vision?.outputImage ?? filters?.wcag?.outputImage
    }
}

extension MetalCameraVC : MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in mtkview: MTKView) {
        
        image = image.transformed(by: scaleToScreenBounds)
        image = image.cropped(to: mtkview.drawableSize.zeroOriginRect())

        guard let buffer = metalCommandQueue.makeCommandBuffer(),
              let currentDrawable = mtkview.currentDrawable
        else { return }
        
        ciContext.render(image,
                         to: currentDrawable.texture,
                         commandBuffer: buffer,
                         bounds: mtkview.drawableSize.zeroOriginRect(),
                         colorSpace: CGColorSpaceCreateDeviceRGB())
        
        buffer.present(currentDrawable)
        buffer.commit()
    }
    
    func setDrawableScaleToScreenTransform() {
        session?.connections.first?.videoOrientation = lastOrientation
        
        let videoSize = videoOutput?.outputSize ?? mtkView.drawableSize
        
        let widthRatio = mtkView.drawableSize.width / videoSize.width
        let heightRatio = mtkView.drawableSize.height / videoSize.height
        let scale = max(widthRatio, heightRatio)
        
        scaleToScreenBounds = CGAffineTransform(scaleX: scale, y: scale)
    }
}

// MARK: - App State

extension MetalCameraVC {
    
    func monitorSceneChanges() {
        
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in self?.pause() }
            .store(in: &sceneMonitors)
        
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in self?.start() }
            .store(in: &sceneMonitors)
    }
}


// MARK: - Intents

extension MetalCameraVC: CameraController {
    
    var exposureBiasLimits: (min: Float, max: Float) {
        guard let device = currentDevice else { return (-6, -6) }
        return (device.minExposureTargetBias, device.maxExposureTargetBias)
    }
    
    func updateExposureDelegate() {
        let limits = exposureBiasLimits
        DispatchQueue.main.async { [weak self] in
            self?.exposureDelegate?.updateExposureLimits(min: limits.min, max: limits.max)
        }
    }
    
    /// Relative position 0...1
    func autoExpose(at point: CGPoint) {
        
        videoOutputQueue.async { [weak self] in
            guard let self = self,
                  self.currentDevice?.isExposureModeSupported(.autoExpose) == true
            else { return }
            self.isConfiguringCamera = true
    
            do {
                try self.currentDevice?.lockForConfiguration()
   
                self.currentDevice?.setExposureTargetBias(0, completionHandler: nil)

                if self.currentDevice?.isExposurePointOfInterestSupported == true {
                    self.currentDevice?.exposurePointOfInterest = point
                }
                self.currentDevice?.exposureMode = .autoExpose

                self.currentDevice?.unlockForConfiguration()
                
            } catch let error {
                NSLog("Manual Exposure: \(error.localizedDescription)")
            }
            self.isConfiguringCamera = false
            self.exposureDelegate?.updateExposureBias(bias: 0)
        }
    }
    
    func setExposure(_ ev: Float) {
        videoOutputQueue.async { [weak self] in
            guard let self = self,
                  self.currentDevice?.isExposureModeSupported(.locked) == true
            else { return }
            self.isConfiguringCamera = true
            let limits = self.exposureBiasLimits
            let safeEV = min(limits.max, max(limits.min, ev))
            do {
                try self.currentDevice?.lockForConfiguration()
                self.currentDevice?.setExposureTargetBias(safeEV, completionHandler: nil)
                self.currentDevice?.unlockForConfiguration()
                
            } catch let error {
                NSLog("Manual Exposure: \(error.localizedDescription)")
            }
            self.isConfiguringCamera = false
        }
    }
    
    func captureImage() {
        captureNextFrame = true
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.mtkView.alpha = 0
        }
        UIView.animate(withDuration: 0.1, delay: 0.25, options: .curveEaseOut) {
            self.mtkView.alpha = 1
        }
    }
    
    func switchCameraInput(completion: @escaping () -> Void) {
        guard !isConfiguringCamera,
              let backInput = backInput,
              let selfieInput = selfieInput
        else { return }
        
        isConfiguringCamera = true
        session?.beginConfiguration()
        
        if session?.inputs.first === self.backInput {
            session?.removeInput(backInput)
            guard session?.canAddInput(selfieInput)  == true else { return }
            session?.addInput(selfieInput)
            videoOutput?.connections.first?.isVideoMirrored = true
            videoOutput?.connections.first?.videoOrientation = lastOrientation
            
        } else {
            session?.removeInput(selfieInput)
            guard session?.canAddInput(backInput) == true else { return }
            session?.addInput(backInput)
            videoOutput?.connections.first?.isVideoMirrored = false
            videoOutput?.connections.first?.videoOrientation = lastOrientation
        }
        
        session?.commitConfiguration()
        updateExposureDelegate()
        isConfiguringCamera = false
        completion()
    }
    
    func start() {
        videoOutputQueue.async {
            guard self.session?.isRunning == false else { return }
            self.session?.startRunning()
        }
    }
    
    func pause() {
        videoOutputQueue.async {
            guard self.session?.isRunning == true else { return }
            self.session?.stopRunning()
        }
    }
}
