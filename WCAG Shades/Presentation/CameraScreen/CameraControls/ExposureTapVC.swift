//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

final class ExposureTapVC: UIViewController {
    
    private weak var camera: CameraController?
    private lazy var tapSpot: UIView = {
        let frame = CGRect(origin: .zero, size: .init(square: .colorButtonDiameter))
        let view = UIView(frame: frame)
        
        let layer = CAShapeLayer()
        layer.path = CGPath(ellipseIn: view.bounds, transform: nil).copy(strokingWithWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: 0)
        layer.fillColor = UIColor.white.cgColor
        layer.contentsGravity = .resizeAspectFill
        
        let image = UIImage(systemName: Symbols.brightness)
        let symbol = UIImageView(image: image)
        symbol.tintColor = .white.withAlphaComponent(0.75)
        symbol.frame = frame.insetBy(dx: frame.width * 0.3, dy: frame.height * 0.3)
        
        view.layer.addSublayer(layer)
        view.addSubview(symbol)
        view.alpha = 0
        return view
    }()
    
    init(_ camera: CameraController?) {
        self.camera = camera
        super.init(nibName: nil, bundle: nil)
        addTapGesture()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    lazy var spotX: NSLayoutConstraint = tapSpot.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    lazy var spotY: NSLayoutConstraint = tapSpot.centerYAnchor.constraint(equalTo: view.centerYAnchor)
}

extension ExposureTapVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tapSpot)
        tapSpot.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let diameter = UIFontMetrics.default.scaledValue(for: .colorButtonDiameter)
        NSLayoutConstraint.activate([
            tapSpot.widthAnchor.constraint(equalToConstant: diameter),
            tapSpot.heightAnchor.constraint(equalToConstant: diameter)
        ])
    }
    
    func addTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func tapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        let point = location.relativelyScaledIn(view.bounds)
        tapSpot.frame.origin = location
        print(location)
        view.setNeedsUpdateConstraints()
        camera?.autoExpose(at: point)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) { [self] in
            tapSpot.alpha = 1
            tapSpot.transform = .init(scaleX: 1.1, y: 1.1).rotated(by: .pi / 20)
        } completion: { _ in
            UIView.animate(withDuration: 0.12, delay: 0, options: .curveEaseIn) { [self] in
                tapSpot.alpha = 0
                tapSpot.transform = .init(scaleX: 0.6, y: 0.6).rotated(by: -.pi / 8)
            } completion: { [self] _ in
                tapSpot.transform = .identity
            }
        }
    }
}
