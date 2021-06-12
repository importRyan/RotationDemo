//  © 2021 Ryan Ferrell. github.com/importRyan


import Foundation

public enum WCAGThreshold: CaseIterable {
    case meaningfulColors
    case strongAA
    case bodyAA
    case strongAAA
    case bodyAAA
    case off
    
    public var value: Float {
        switch self {
            case .meaningfulColors: return  3
            case .bodyAA: return            4.5
            case .bodyAAA: return           7
            case .strongAA: return          3
            case .strongAAA: return         4.5
            case .off: return               0
        }
    }
    
    public static let activeCases: [WCAGThreshold] = [
        .meaningfulColors,
        .strongAA,
        .bodyAA,
        .strongAAA,
        .bodyAAA,
    ]
}
