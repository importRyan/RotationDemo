import Foundation
import CoreImage

class FilterVendor: NSObject, CIFilterConstructor {
    
    public static let WCAGContrastFilterName = "WCAGContrastFilter"
    public static let MonochromatFilterName = "Monochromat"
    public static let MachadoTritanFilterName = "Tritan"
    public static let MachadoDeutanFilterName = "Deutan"
    public static let MachadoProtanFilterName = "Protan"
    
    
    static func registerFilters() {
        let classAttributes = [kCIAttributeFilterCategories: ["CustomFilters"]]
        
        WCAGContrastFilter.registerName(WCAGContrastFilterName,
                                        constructor: FilterVendor(),
                                        classAttributes: classAttributes)
        
        Monochromat.registerName(MonochromatFilterName,
                                 constructor: FilterVendor(),
                                 classAttributes: classAttributes)
        
        Tritan.registerName(MachadoTritanFilterName,
                            constructor: FilterVendor(),
                            classAttributes: classAttributes)
        
        Deutan.registerName(MachadoDeutanFilterName,
                            constructor: FilterVendor(),
                            classAttributes: classAttributes)
        
        Protan.registerName(MachadoProtanFilterName,
                            constructor: FilterVendor(),
                            classAttributes: classAttributes)
    }
    
    func filter(withName name: String) -> CIFilter? {
        switch name {
            case FilterVendor.WCAGContrastFilterName: return WCAGContrastFilter()
            case FilterVendor.MonochromatFilterName: return Monochromat()
            case FilterVendor.MachadoTritanFilterName: return Tritan()
            case FilterVendor.MachadoDeutanFilterName: return Deutan()
            case FilterVendor.MachadoProtanFilterName: return Protan()
            default: return nil
        }
    }
}

