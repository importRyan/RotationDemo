//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

enum FontNames {
    case pacifico
    case itim
    
    var fontName: String {
        switch self {
            case .pacifico: return "Pacifico-Regular"
            case .itim: return "Itim-Regular"
        }
    }
    
    func dynamic(style: UIFont.TextStyle, adding: CGFloat = 0) -> UIFont {
        let system = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        guard let font = UIFont(name: fontName, size: system.pointSize + adding)
        else { fatalError("Font mispelled.") }
        return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
    }
    
    func dynamic(style: UIFont.TextStyle, adding: CGFloat = 0, max: CGFloat) -> UIFont {
        let system = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        guard let font = UIFont(name: fontName, size: system.pointSize + adding)
        else { fatalError("Font mispelled.") }
        return UIFontMetrics(forTextStyle: style).scaledFont(for: font, maximumPointSize: max)
    }
    
    func dynamic(size: CGFloat, max: CGFloat) -> UIFont {
        guard var font = UIFont(name: fontName, size: size)
        else { fatalError("Font mispelled.") }
        font = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: max)
        return font
    }
}
