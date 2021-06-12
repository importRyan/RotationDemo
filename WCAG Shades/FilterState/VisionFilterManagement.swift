//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit
import Combine

protocol VisionFilterManagement {}

extension VisionFilterManagement {
    
    func makeFilter(vision: ColorVision) -> CIFilter? {
        switch vision {
            case .monochromacy:
                return CIFilter(name: FilterVendor.MonochromatFilterName)
            
            case .tritanopia:
                return CIFilter(name: FilterVendor.MachadoTritanFilterName)
                
            case .deuteranopia:
                return CIFilter(name: FilterVendor.MachadoDeutanFilterName)
                
            case .protanopia:
                return CIFilter(name: FilterVendor.MachadoProtanFilterName)
                
            case .typicalTrichromacy: return nil
        }
    }
}
