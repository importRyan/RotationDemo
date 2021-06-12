//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

class FadeScrollView: UIScrollView, UIScrollViewDelegate {
    
    let fadePercentage: Double = 0.2
    let gradientLayer = CAGradientLayer()
    let transparentColor = UIColor.clear.cgColor
    let opaqueColor = UIColor.black.cgColor
    
    var topOpacity: CGColor {
        let scrollViewHeight = frame.size.height
        let scrollContentSizeHeight = contentSize.height
        let scrollOffset = contentOffset.y
        
        let alpha:CGFloat = (scrollViewHeight >= scrollContentSizeHeight || scrollOffset <= 0) ? 1 : 0
        
        let color = UIColor(white: 0, alpha: alpha)
        return color.cgColor
    }
    
    var bottomOpacity: CGColor {
        let scrollViewHeight = frame.size.height
        let scrollContentSizeHeight = contentSize.height
        let scrollOffset = contentOffset.y
        
        let alpha:CGFloat = (scrollViewHeight >= scrollContentSizeHeight || scrollOffset + scrollViewHeight >= scrollContentSizeHeight) ? 1 : 0
        
        let color = UIColor(white: 0, alpha: alpha)
        return color.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.delegate = self
        let maskLayer = CALayer()
        maskLayer.frame = self.bounds
        
        gradientLayer.frame = CGRect(x: self.bounds.origin.x, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        gradientLayer.colors = [topOpacity, opaqueColor, opaqueColor, bottomOpacity]
        gradientLayer.locations = [0, NSNumber(floatLiteral: fadePercentage), NSNumber(floatLiteral: 1 - fadePercentage), 1]
        maskLayer.addSublayer(gradientLayer)
        
        self.layer.mask = maskLayer
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        gradientLayer.colors = [topOpacity, opaqueColor, opaqueColor, bottomOpacity]
    }
    
}


class Fade: UIView {
    
    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.startPoint = CGPoint(x: 0.5, y: 0)
        l.endPoint = CGPoint(x: 0.5, y: 1)
        let baseColor = UIColor.white
        l.colors = [
            baseColor.withAlphaComponent(0),
            baseColor.withAlphaComponent(1),
        ].map{$0.cgColor}
        layer.addSublayer(l)
        return l
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
