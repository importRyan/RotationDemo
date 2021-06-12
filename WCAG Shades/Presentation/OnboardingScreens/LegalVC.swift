//  © 2021 Ryan Ferrell. github.com/importRyan

import UIKit

final class LegalVC: UIViewController {
    
    private lazy var scroll = FadeScrollView()
    private lazy var scrollContent = UIView()
    private lazy var stackView = UIStackView()
    
    private lazy var instruction = TropicalHeadline(alpha: 1, text: "Legal ", color: Colors.SunBright.ui)
    private lazy var explanation = TropicalExplanation(alpha: 1, text: "Color vision deficit simulation is performed using the widely-adopted method published by Gustavo M. Machado, Manuel M. Oliveira, and Leandro A. F. Fernandes.")
    
    private lazy var explanation2 = TropicalExplanation(alpha: 1, text: "This app also adapts illustrations by the artists below, obtained from Freepix.")

    private lazy var closeButton: UIButton = {
        let b = CloseButton(tint: Colors.TealBackground.ui)
        b.addTarget(self, action: #selector(closeSheet), for: .touchUpInside)
        return b
    }()
    
    private lazy var machado: UIButton = {
        let b = UIButton(type: .custom)
        b.setTitle("Read Machado et al. 2009", for: .normal)
        b.addTarget(self, action: #selector(launchMachado), for: .touchUpInside)
        b.setTitleColor(Colors.TealBackground.ui, for: .normal)
        b.titleLabel?.font = FontNames.itim.dynamic(style: .title3)
        return b
    }()
    
    private lazy var tropical: UIButton = {
        let b = UIButton(type: .custom)
        b.setTitle("Topical sea by pikisuperstar", for: .normal)
        b.addTarget(self, action: #selector(launchTropical), for: .touchUpInside)
        b.setTitleColor(Colors.TealBackground.ui, for: .normal)
        b.titleLabel?.font = FontNames.itim.dynamic(style: .title3)
        return b
    }()
    
    private lazy var isometric: UIButton = {
        let b = UIButton(type: .custom)
        b.setTitle("Shades by macrovector", for: .normal)
        b.addTarget(self, action: #selector(launchIsometric), for: .touchUpInside)
        b.setTitleColor(Colors.TealBackground.ui, for: .normal)
        b.titleLabel?.font = FontNames.itim.dynamic(style: .title3)
        return b
    }()
    
    init() { super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError() }
    
    private lazy var constraintsPortrait = makeConstraintsPortrait()
    
}

// MARK: - Intents

extension LegalVC {
    
    @objc func closeSheet() {
        dismiss(animated: true) {
        }
    }
    
    @objc func launchMachado() {
        let url = URL(string: "https://www.inf.ufrgs.br/~oliveira/pubs_files/CVD_Simulation/CVD_Simulation.html")!
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func launchTropical() {
        let url = URL(string: "http://www.freepik.com")!
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func launchIsometric() {
        let url = URL(string: "http://www.freepik.com")!
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}


// MARK: - Setup

extension LegalVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.VeryDarkPurpleBackground.ui
        view.addSubview(scroll)
        
        scroll.addSubview(scrollContent)
        scrollContent.addSubview(stackView)
        
        [explanation, explanation2].forEach {
            $0.textAlignment = .left
            $0.font = FontNames.itim.dynamic(style: .title2)
            $0.textColor = Colors.SunBright.ui
        }
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 22
        
        stackView.addArrangedSubview(instruction)
        stackView.addArrangedSubview(explanation)
        stackView.addArrangedSubview(machado)
        stackView.addArrangedSubview(explanation2)
        stackView.addArrangedSubview(isometric)
        stackView.addArrangedSubview(tropical)
        
        stackView.setCustomSpacing(40, after: machado)
        
        view.addSubview(closeButton)
        
        [scroll, scrollContent, stackView, closeButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NSLayoutConstraint.activate(constraintsPortrait)
    }
    
}

private extension LegalVC {
    func makeConstraintsPortrait() -> [NSLayoutConstraint] {
        .pinning(scrollContent, to: scroll)
            + .pinning(scroll, to: view)
            + [
                closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
                closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
                closeButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
                closeButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
                
                scrollContent.widthAnchor.constraint(equalTo: scroll.widthAnchor),
                
                stackView.widthAnchor.constraint(equalTo: scrollContent.widthAnchor, multiplier: 0.8),
                stackView.centerXAnchor.constraint(equalTo: scrollContent.centerXAnchor),
                stackView.topAnchor.constraint(equalTo: scrollContent.topAnchor, constant: 40),
                stackView.bottomAnchor.constraint(equalTo: scrollContent.bottomAnchor, constant: -40)
            ]
    }
}
