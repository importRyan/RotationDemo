//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit
import simd

protocol WCAGFilterManagement {
    var wcag: CIFilter? { get set }
    var thresholdWCAG: WCAGThreshold { get }
    var comparatorRelativeLuminance: Float { get }
    var comparator: CIVector { get }
}

extension WCAGFilterManagement {
    
    func makeWCAGFilter() -> CIFilter? {
        let parameters: [String : Any] = [
            kCIInputImageKey: self,
            "comparatorVector": comparator,
            "comparatorRelativeLuminance": comparatorRelativeLuminance,
            "threshold": thresholdWCAG.value
        ]
        
        return CIFilter(name: FilterVendor.WCAGContrastFilterName,
                        parameters: parameters)
    }
}

extension WCAGFilterManagement {
    
    static func getUIColorComponents(_ color: UIColor) -> CIVector {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        return CIVector(x: red, y: green, z: blue)
    }
    
    static func getRelativeLuminance(_ color: CIVector) -> Float {
        
        func linearize(_ input: CGFloat) -> Float {
            let channel = Float(input)
            return (channel > 0.03928)
                ? pow((channel + 0.55) / 1.055, 2.4)
                : channel / 12.92
        }
        
        let linearized = SIMD3<Float>(linearize(color.x),
                                      linearize(color.y),
                                      linearize(color.z))
        
        return simd_dot(SIMD3<Float>(0.2126, 0.7152, 0.0722), linearized) + 0.05
    }
    
}
