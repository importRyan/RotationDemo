//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

class TropicalHeadline: UILabel {
    
    init(alpha: CGFloat, text: String, color: UIColor = Colors.DarkPurpleHeadline.ui) {
        super.init(frame: .zero)
        configure(with: text, alphaStarting: alpha, color: color)
    }
    
    let startTransform = CGAffineTransform(rotationAngle: -4 / 57)
    
    required init?(coder: NSCoder) { fatalError() }

}

extension TropicalHeadline {
    
    func configure(with text: String, alphaStarting: CGFloat, color: UIColor) {
        
        let pad: CGFloat = UIDevice.current.sizing == .tablet ? 18 : 0
        let large: CGFloat = UIDevice.current.sizing == .large ? 8 : 0
        let medium: CGFloat = UIDevice.current.sizing == .medium ? 8 : 0
        let constrained: CGFloat = UIDevice.current.sizing == .constrained ? -2 : 0
        
        font = FontNames.pacifico.dynamic(style: .title1, adding: pad + large + medium + constrained)
        
        adjustsFontForContentSizeCategory = true
        textColor = color
        alpha = alphaStarting
        setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
        
        let string = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 0.8
        style.alignment = .center
        style.lineBreakMode = .byWordWrapping
        numberOfLines = 0
        
        string.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, string.length))
        attributedText = string
        
        transform = .init(rotationAngle: -4 / 57)
    }
}
