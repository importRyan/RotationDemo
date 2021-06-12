import UIKit
import Combine

protocol FilterState: AnyObject {
    
    var vision: CIFilter? { get }
    var wcag: CIFilter? { get }

    /// Sets vision CIFilter by sending the desired update
    var visionSimulation: CurrentValueSubject<ColorVision,Never> { get }

    /// Set new colors into the CIFilter by sending the desired update
    var comparatorColor: CurrentValueSubject<UIColor,Never> { get }
    /// Set threshold for CIFIlter
    func setThreshold(_ new: WCAGThreshold)
    /// Read current threshold state
    var thresholdWCAG: WCAGThreshold { get }
}
