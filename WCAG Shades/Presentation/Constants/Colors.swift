//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

enum Colors: String {
    case ExposureSliderLabel
    case ColorButtonOuterRing
    case DarkPurpleHeadline
    case Sun
    case SunBright
    case VeryDarkPurpleBackground
    case TealBackground
    case TealForeground
    case PinkLink
    
    var ui: UIColor { UIColor(named: rawValue)! }
}
