//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

class TropicalButton: UIButton {
    
    let startTransform = CGAffineTransform(scaleX: 0.8, y: 0.8).rotated(by: -5/57)
    
    private let text: String
    private let textColor: UIColor
    private let horizontalInsets: CGFloat
    private let gradientStart: UIColor
    private let gradientEnd: UIColor
    
    init(frame: CGRect,
         text: String,
         textColor: UIColor = Colors.Sun.ui,
         horizontalInsets: CGFloat = 20,
         start: UIColor = Colors.DarkPurpleHeadline.ui,
         end: UIColor = Colors.DarkPurpleHeadline.ui) {
        self.text = text
        self.textColor = textColor
        self.horizontalInsets = horizontalInsets
        self.gradientStart = start
        self.gradientEnd = end
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override var titleEdgeInsets: UIEdgeInsets {
         didSet {
             invalidateIntrinsicContentSize()
         }
     }

     override var intrinsicContentSize: CGSize {
         var sizeWithInsets = titleLabel?.intrinsicContentSize ?? super.intrinsicContentSize
         sizeWithInsets.width += titleEdgeInsets.left + titleEdgeInsets.right
         sizeWithInsets.height += titleEdgeInsets.top + titleEdgeInsets.bottom
         return sizeWithInsets
     }
}

extension TropicalButton {
    
    func configure() {
        setBackgroundImage(.imageWithGradient(
                            from: gradientStart,
                            to: gradientEnd),
                           for: .normal)
        layer.cornerRadius = 13
        clipsToBounds = true
      
        titleEdgeInsets = .init(vertical: 5, horizontal: horizontalInsets)
        titleLabel?.adjustsFontSizeToFitWidth = true
        setTitleColor(textColor, for: .normal)
        
        let pad: CGFloat = UIDevice.current.sizing == .tablet ? 8 : 0
        let constrained: CGFloat = UIDevice.current.sizing == .constrained ? -5 : 0
        titleLabel?.font = FontNames.pacifico.dynamic(
            style: .largeTitle,
            adding: pad + constrained, max: 50)
        
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
        titleLabel?.adjustsFontForContentSizeCategory = true
        setAttributedTitle(attributedTighterMultilineString(text, 1), for: .normal)
        transform = startTransform
    }
}

