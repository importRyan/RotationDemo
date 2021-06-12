import Foundation
import CoreImage

class Monochromat: CIFilter {
    
    @objc dynamic var inputImage: CIImage?
    
    override var attributes: [String : Any] {
        return [
            kCIAttributeFilterDisplayName: "Monochromat",
            
            "inputImage": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIImage",
                kCIAttributeDisplayName: "Image",
                kCIAttributeType: kCIAttributeTypeImage],
        ]
    }
    
    private lazy var kernel: CIColorKernel? = {
        guard let url = Bundle.main.url(forResource: "default", withExtension: "metallib"),
              let data = try? Data(contentsOf: url)
        else { return nil }
        return try? CIColorKernel(functionName: "monochromat_kernel",
                                  fromMetalLibraryData: data,
                                  outputPixelFormat: CIFormat.RGBAh)
    }()
    
    override var outputImage: CIImage? {
        guard let kernel = kernel, let image = inputImage
        else { return nil }
        
        return kernel.apply(extent: image.extent,
                            roiCallback: { (_, _) in .null },
                            arguments: [CISampler(image: image)])
    }
    
    override var description: String {
        return("Simulate monochromatism (limitation: no peer-reviewed algorithm exists)")
    }
    
}

class Tritan: CIFilter {
    
    @objc dynamic var inputImage: CIImage?
    
    override var attributes: [String : Any] {
        return [
            kCIAttributeFilterDisplayName: "Tritanopia",
            
            "inputImage": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIImage",
                kCIAttributeDisplayName: "Image",
                kCIAttributeType: kCIAttributeTypeImage],
        ]
    }
    
    private lazy var kernel: CIColorKernel? = {
        guard let url = Bundle.main.url(forResource: "default", withExtension: "metallib"),
              let data = try? Data(contentsOf: url)
        else { return nil }
        return try? CIColorKernel(functionName: "tritan_kernel",
                                  fromMetalLibraryData: data,
                                  outputPixelFormat: CIFormat.RGBAh)
    }()
    
    override var outputImage: CIImage? {
        guard let kernel = kernel, let image = inputImage
        else { return nil }
        
        return kernel.apply(extent: image.extent,
                            roiCallback: { (_, _) in .null },
                            arguments: [CISampler(image: image)])
    }
    
    override var description: String {
        return("Machado simulation of tritanopia")
    }
    
}


class Protan: CIFilter {
    
    @objc dynamic var inputImage: CIImage?
    
    override var attributes: [String : Any] {
        return [
            kCIAttributeFilterDisplayName: "Protanopia",
            
            "inputImage": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIImage",
                kCIAttributeDisplayName: "Image",
                kCIAttributeType: kCIAttributeTypeImage],
        ]
    }
    
    private lazy var kernel: CIColorKernel? = {
        guard let url = Bundle.main.url(forResource: "default", withExtension: "metallib"),
              let data = try? Data(contentsOf: url)
        else { return nil }
        return try? CIColorKernel(functionName: "protan_kernel",
                                  fromMetalLibraryData: data,
                                  outputPixelFormat: CIFormat.RGBAh)
    }()
    
    override var outputImage: CIImage? {
        guard let kernel = kernel, let image = inputImage
        else { return nil }
        
        return kernel.apply(extent: image.extent,
                            roiCallback: { (_, _) in .null },
                            arguments: [CISampler(image: image)])
    }
    
    override var description: String {
        return("Machado simulation of protanopia")
    }
    
}


class Deutan: CIFilter {
    
    @objc dynamic var inputImage: CIImage?
    
    override var attributes: [String : Any] {
        return [
            kCIAttributeFilterDisplayName: "Deutanopia",
            
            "inputImage": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIImage",
                kCIAttributeDisplayName: "Image",
                kCIAttributeType: kCIAttributeTypeImage],
        ]
    }
    
    private lazy var kernel: CIColorKernel? = {
        guard let url = Bundle.main.url(forResource: "default", withExtension: "metallib"),
              let data = try? Data(contentsOf: url)
        else { return nil }
        return try? CIColorKernel(functionName: "deutan_kernel",
                                  fromMetalLibraryData: data,
                                  outputPixelFormat: CIFormat.RGBAh)
    }()
    
    override var outputImage: CIImage? {
        guard let kernel = kernel, let image = inputImage
        else { return nil }
        
        return kernel.apply(extent: image.extent,
                            roiCallback: { (_, _) in .null },
                            arguments: [CISampler(image: image)])
    }
    
    override var description: String {
        return("Machado simulation of deutanopia")
    }
    
}
