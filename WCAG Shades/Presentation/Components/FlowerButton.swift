//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit
import Combine

final class FlowerButton: UIButton {
    
    weak var userColor: CurrentValueSubject<UIColor,Never>?
    private var updates: AnyCancellable? = nil
    
    private lazy var outerRing: CAShapeLayer = makeOuterRing()
    private lazy var flowerStencil: CALayer = makeFlowerStencil()
    private lazy var userColorCircle: CAShapeLayer = makeUserColorCircle()
    
    init(frame: CGRect, userColor: CurrentValueSubject<UIColor,Never>) {
        self.userColor = userColor
        super.init(frame: frame)
        setupRings()
        updateUserColor(userColor)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private let outerRingWidth: CGFloat = 3
    private let inset: CGFloat = 3
    private let insetReflection: CGFloat = 5
}

// MARK: - State

private extension FlowerButton {
    
    func updateUserColor(_ userColor: CurrentValueSubject<UIColor,Never>) {
        updates = userColor.sink { [weak self] color in
            UIView.animate(withDuration: 0.6) {
                self?.userColorCircle.fillColor = color.cgColor
            }
        }
    }
}

// MARK: - Layers

private extension FlowerButton {
    
    func setupRings() {
        layer.addSublayer(outerRing)
        layer.addSublayer(userColorCircle)
        layer.addSublayer(flowerStencil)
        layer.contentsGravity = .resizeAspectFill
    }
    
    func makeOuterRing() -> CAShapeLayer {
        let path = CGPath.circle(in: frame)
        let shape = CAShapeLayer()
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = Colors.ColorButtonOuterRing.ui.cgColor
        shape.lineWidth = outerRingWidth
        shape.path = path
        return shape
    }
    
    func makeUserColorCircle()  -> CAShapeLayer {
        let pathFrame = frame.insetBy(dx: inset, dy: inset)
        let path = CGPath.circle(in: pathFrame)
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = userColor?.value.cgColor
        return shape
    }
    
    func makeFlowerStencil() -> CALayer {
        let image = Image.ColorButtonStencil.ui
        let stencil = CALayer()
        stencil.contents = image.imageScaled(toSize: layer.frame.size).cgImage
        stencil.frame = CGRect(origin: CGPoint(square: insetReflection / 2),
                               size: CGSize(square: layer.frame.height - insetReflection))
        stencil.contentsGravity = .resizeAspectFill
        return stencil
    }
}
