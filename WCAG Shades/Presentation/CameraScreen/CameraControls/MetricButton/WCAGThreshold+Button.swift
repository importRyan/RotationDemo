//  © 2021 Ryan Ferrell. github.com/importRyan


import Foundation
import UIKit

extension WCAGThreshold {
    
    public var label: String {
        switch self {
            case .meaningfulColors: return  "Meaningful Colors"
            case .bodyAA: return            "Body"
            case .bodyAAA: return           "Body (Enhanced)"
            case .strongAA: return          "Strong"
            case .strongAAA: return         "Strong (Enhanced)"
            case .off: return               "Off"
        }
    }
    
    public var valueString: String {
        switch self {
            case .meaningfulColors: return  "3"
            case .bodyAA: return            "4.5"
            case .bodyAAA: return           "7"
            case .strongAA: return          "3"
            case .strongAAA: return         "4.5"
            case .off: return               "–"
        }
    }
    
    public var menuImage: UIImage {
        switch self {
            case .meaningfulColors: return  Image.Metric3.ui
            case .bodyAA: return            Image.Metric45.ui
            case .bodyAAA: return           Image.Metric7.ui
            case .strongAA: return          Image.Metric3.ui
            case .strongAAA: return         Image.Metric45.ui
            case .off: return               Image.MetricOff.ui
        }
    }
    
    public var buttonImage: UIImage {
        switch self {
            case .meaningfulColors: return  Image.C3.ui
            case .bodyAA: return            Image.C45.ui
            case .bodyAAA: return           Image.C7.ui
            case .strongAA: return          Image.C3.ui
            case .strongAAA: return         Image.C45.ui
            case .off: return               Image.COFF.ui
        }
    }
}
