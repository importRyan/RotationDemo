import Foundation
import CoreImage

class WCAGContrastFilter: CIFilter {
    
    @objc dynamic var inputImage: CIImage?
    @objc dynamic var comparatorVector = CIVector(x: 1, y: 1, z: 1)
    @objc dynamic var comparatorRelativeLuminance = Float(2.5)
    @objc dynamic var threshold = Float(3)
    
    override var attributes: [String : Any] {
        return [
            kCIAttributeFilterDisplayName: "WCAG",
            
            "inputImage": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIImage",
                kCIAttributeDisplayName: "Image",
                kCIAttributeType: kCIAttributeTypeImage],
            
            "comparatorVector": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIVector",
                kCIAttributeDisplayName: "CV",
                kCIAttributeDefault: CIVector(x: 1, y: 1, z: 1),
                kCIAttributeType: kCIAttributeTypePosition3],
            
            "comparatorRelativeLuminance": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "NSNumber",
                kCIAttributeDisplayName: "RL",
                kCIAttributeDefault: 2.5,
                kCIAttributeSliderMin: 0,
                kCIAttributeSliderMax: 2.57,
                kCIAttributeType: kCIAttributeTypeScalar],
            
            "threshold": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "NSNumber",
                kCIAttributeDisplayName: "Threshold",
                kCIAttributeDefault: 3,
                kCIAttributeSliderMin: 3,
                kCIAttributeSliderMax: 7.5,
                kCIAttributeType: kCIAttributeTypeScalar]
        ]
    }
    
    private lazy var kernel: CIColorKernel? = {
        guard let url = Bundle.main.url(forResource: "default", withExtension: "metallib"),
              let data = try? Data(contentsOf: url)
        else { return nil }
        return try? CIColorKernel(functionName: "wcag_kernel",
                                  fromMetalLibraryData: data,
                                  outputPixelFormat: CIFormat.RGBAh)
    }()
    
    override var outputImage: CIImage? {
        guard let kernel = kernel, let image = inputImage
        else { return nil }
        
        return kernel.apply(extent: image.extent,
                            roiCallback: { (_, _) in .null },
                            arguments: [CISampler(image: image),
                                        comparatorVector,
                                        comparatorRelativeLuminance,
                                        threshold
                            ])
    }
    
    override var description: String {
        return("See only colors with a passing contrast ratio")
    }
    
}
