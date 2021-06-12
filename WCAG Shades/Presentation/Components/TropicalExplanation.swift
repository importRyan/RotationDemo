//  © 2021 Ryan Ferrell. github.com/importRyan

import UIKit

class TropicalExplanation: UILabel {
    
    init(alpha: CGFloat, text: String, lineHeightMultiple: CGFloat = 0.9) {
        super.init(frame: .zero)
        configure(with: text, alphaStarting: alpha, lineHeightMultiple)
    }
    
    let startTransform = CGAffineTransform(rotationAngle: -4 / 57)
    
    required init?(coder: NSCoder) { fatalError() }

}

extension TropicalExplanation {
    
    func configure(with text: String, alphaStarting: CGFloat, _ lineHeightMultiple: CGFloat) {
        
        let pad: CGFloat = UIDevice.current.sizing == .tablet ? 8 : 0
        let large: CGFloat = UIDevice.current.sizing == .large ? 3 : 0
        let medium: CGFloat = UIDevice.current.sizing == .medium ? 3 : 0
        let constrained: CGFloat = UIDevice.current.sizing == .constrained ? -2 : 0
        
        font = FontNames.itim.dynamic(style: .title1, adding: pad + large + medium + constrained)
        adjustsFontForContentSizeCategory = true
        textColor = Colors.DarkPurpleHeadline.ui
        alpha = alphaStarting
        preferredMaxLayoutWidth = UIDevice.current.userInterfaceIdiom == .pad ? 450 : 250
        setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
        numberOfLines = 0
        attributedText = attributedTighterMultilineString(text, lineHeightMultiple, paragraphSpacing: 20)
    }
}

func attributedTighterMultilineString(_ text: String, _ lineHeightMultiple: CGFloat, paragraphSpacing: CGFloat? = nil) -> NSMutableAttributedString { 
    let string = NSMutableAttributedString(string: text)
    let style = NSMutableParagraphStyle()
    style.lineHeightMultiple = lineHeightMultiple
    style.alignment = .center
    style.lineBreakMode = .byWordWrapping
    if let spacing = paragraphSpacing {
        style.paragraphSpacing = spacing
    }
    style.firstLineHeadIndent = 0
    string.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, string.length))
    return string
}
