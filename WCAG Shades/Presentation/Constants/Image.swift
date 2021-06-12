//  © 2021 Ryan Ferrell. github.com/importRyan

import UIKit

enum Image: String {
    case OnboardingBackground
    case WCAGPinkShades
    
    case ExposureKnob
    case ExposureTicks
    case PurplePalms
    
    case ColorButtonStencil
    
    case MetricOff
    case Metric3
    case Metric45
    case Metric7
    case COFF
    case C3
    case C45
    case C7
    
    var ui: UIImage { UIImage(named: rawValue)! }
}
