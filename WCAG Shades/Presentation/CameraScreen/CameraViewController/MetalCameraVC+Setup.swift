//  © 2021 Ryan Ferrell. github.com/importRyan

import UIKit
import AVFoundation
import MetalKit
import Combine


// 1 Metal & Filter

extension MetalCameraVC {
    
    func setupMetal(){
        metalDevice = MTLCreateSystemDefaultDevice()
        mtkView.device = metalDevice
        mtkView.isPaused = true
        mtkView.enableSetNeedsDisplay = false
        metalCommandQueue = metalDevice.makeCommandQueue()
        mtkView.delegate = self
        mtkView.framebufferOnly = false
        ciContext = CIContext(
            mtlDevice: metalDevice,
            options: [.workingColorSpace: CGColorSpace(name: CGColorSpace.sRGB)!])
    }
}

// 2 AVCapture

extension MetalCameraVC {
    
    func setupAVCaptureSession() {
        session = AVCaptureSession()
        session?.beginConfiguration()
        session?.automaticallyConfiguresCaptureDeviceForWideColor = false
        setupAVInputs()
        setupAVOutputs()
        setDrawableScaleToScreenTransform()
        session?.automaticallyConfiguresApplicationAudioSession = false
        session?.usesApplicationAudioSession = false
        session?.commitConfiguration()
        session?.startRunning()
        updateExposureDelegate()
    }
    
    func setupAVInputs() {
        guard let back = setupBackCamera(),
              let front = setupSelfieCamera(),
              let backInput = try? AVCaptureDeviceInput(device: back),
              let frontInput = try? AVCaptureDeviceInput(device: front),
              session?.canAddInput(backInput) == true
        else {
            showAlert(with: "Rear camera not available for use.")
            return
        }
        backCamera = back
        selfieCamera = front
        
        self.backInput = backInput
        self.selfieInput = frontInput
        session?.addInput(backInput)
    }
    
    func setupBackCamera() -> AVCaptureDevice? {
        let session = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera],
            mediaType: .video,
            position: .back)
        
        let device = session.devices.first
        try? device?.lockForConfiguration()
        setupExposureFocusWhiteBalance(device)
        device?.unlockForConfiguration()
        return device
    }
    
    func setupSelfieCamera() -> AVCaptureDevice? {
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        try? device?.lockForConfiguration()
        setupExposureFocusWhiteBalance(device)
        device?.unlockForConfiguration()
        return device
    }
    
    private func setupExposureFocusWhiteBalance(_ device: AVCaptureDevice?) {
        if device?.isFocusModeSupported(.continuousAutoFocus) == true {
            device?.focusMode = .continuousAutoFocus
        }
        if device?.isExposureModeSupported(.autoExpose) == true {
            device?.exposureMode = .autoExpose
        }
        if device?.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) == true {
            device?.whiteBalanceMode = .continuousAutoWhiteBalance
        }
    }
    
    func setupAVOutputs() {
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput?.setSampleBufferDelegate(self, queue: videoOutputQueue)
        guard session?.canAddOutput(videoOutput!) == true else {
            showAlert(with: "Camera output not available for use.")
            return
        }
        session?.addOutput(videoOutput!)
    }
    
}
