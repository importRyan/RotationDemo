//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

final class SelectAColorVC: UIViewController {
    
    private lazy var scroll = FadeScrollView()
    private lazy var scrollContent = UIView()
    private lazy var stackView = UIStackView()
    
    private lazy var instruction = TropicalHeadline(alpha: 0, text: "Tap the\nColor Flower")
    private lazy var pickColor = PickColorButtonVC(filter: appDelegate().state.filter, overrideSize: .colorButtonDiameter * 1.5)
    private lazy var explanation = TropicalExplanation(alpha: 1, text: "to WCAG test that color against every camera pixel")

    private lazy var ctaButton: UIButton = makeNextButton()
    
    init() { super.init(nibName: nil, bundle: nil) }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private lazy var constraintsPortrait = makePortraitConstraints()
    
    private lazy var addExtraVerticalPadding = UIDevice.current.userInterfaceIdiom == .pad && UIApplication.shared.preferredContentSizeCategory < .accessibilityLarge
    private lazy var scrollTopPaddingPortrait = scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: addExtraVerticalPadding ? 80 : 20)
    private lazy var scrollTopPaddingLandscape = scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: addExtraVerticalPadding ? 20 : 20)
}

// MARK: - Intents

extension SelectAColorVC {

    @objc func tapCTA() {
        askForAVPermissions()
    }

}

extension SelectAColorVC: AVPermissionsDelegate {
    
    func cameraPermissionsDenied() {
        navigationController?.pushViewController(CameraPermissionsFailedVC(), animated: true)
    }
    
    func cameraPermissionsAccepted() {
        navigationController?.pushViewController(CameraScreenVC(filter: appDelegate().state.filter), animated: true)
        appDelegate().state.markOnboardingCompleted()
    }
}


// MARK: - Setup

extension SelectAColorVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.SunBright.ui
        view.addSubview(scroll)
        view.addSubview(ctaButton)
        
        scroll.addSubview(scrollContent)
        scrollContent.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 22
        
        addChild(pickColor)
        pickColor.didMove(toParent: self)
        
        stackView.addArrangedSubview(instruction)
        stackView.addArrangedSubview(pickColor.view)
        stackView.addArrangedSubview(explanation)
        stackView.setCustomSpacing(40, after: pickColor.view)
        
        markupAccessibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NSLayoutConstraint.activate(constraintsPortrait)
        NSLayoutConstraint.activate([UIDevice.current.orientation.isLandscape
                                        ? scrollTopPaddingLandscape
                                        : scrollTopPaddingPortrait])
        instruction.transform = instruction.transform.translatedBy(x: 0, y: 20)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateAppearances()
    }
    
    private func animateAppearances() {
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseOut, animations: {
            self.instruction.transform = self.instruction.transform.translatedBy(x: 0, y: -20)
            self.instruction.alpha = 1
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.9, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: []) {
            self.ctaButton.transform = .identity.rotated(by: -5/57)
        }
    }
    
    private func maxExplanationWidth() -> CGFloat {
        min(250, max(scrollContent.bounds.width, 300))
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if size.isPortrait {
            NSLayoutConstraint.deactivate([scrollTopPaddingLandscape])
            NSLayoutConstraint.activate([scrollTopPaddingPortrait])
        } else {
            NSLayoutConstraint.deactivate([scrollTopPaddingPortrait])
            NSLayoutConstraint.activate([scrollTopPaddingLandscape])
        }
    }
    
}

private extension SelectAColorVC {
    
    func markupAccessibility() {
        instruction.accessibilityLabel =  [instruction.text!, " Button ", explanation.text!].joined()
        instruction.accessibilityTraits = .header
        explanation.isAccessibilityElement = false
        ctaButton.accessibilityLabel = "Start Camera"
        ctaButton.accessibilityTraits = .causesPageTurn
    }
    
    func makeNextButton() -> UIButton {
        let button = TropicalButton(frame: .zero, text: "Start",
                                    textColor: Colors.SunBright.ui,
                                    horizontalInsets: 30,
                                    start: Colors.DarkPurpleHeadline.ui,
                                    end: Colors.DarkPurpleHeadline.ui)
        button.addTarget(self, action: #selector(tapCTA), for: .touchUpInside)
        return button
    }
    
    func makePortraitConstraints() -> [NSLayoutConstraint] {
        [scroll, scrollContent, stackView, ctaButton, instruction, explanation, pickColor.view]
            .forEach { $0?.translatesAutoresizingMaskIntoConstraints = false }
        
        let ctaBottom: CGFloat = UIDevice.current.userInterfaceIdiom == .pad
        ? addExtraVerticalPadding ? -90 : -70
        : view.safeAreaInsets.bottom == 0 ? -45 : -20
        
        print(view.safeAreaInsets)
        
        return .pinning(scrollContent, to: scroll)
            + [
                scroll.bottomAnchor.constraint(equalTo: ctaButton.topAnchor, constant: 0),
                scroll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                scroll.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                
                scrollContent.widthAnchor.constraint(equalTo: scroll.widthAnchor),
                
                stackView.widthAnchor.constraint(equalTo: scrollContent.widthAnchor, multiplier: 0.8),
                stackView.centerXAnchor.constraint(equalTo: scrollContent.centerXAnchor),
                stackView.topAnchor.constraint(equalTo: scrollContent.topAnchor, constant: 20),
                stackView.bottomAnchor.constraint(equalTo: scrollContent.bottomAnchor, constant: -60),
                
                pickColor.view.widthAnchor.constraint(equalToConstant: .colorButtonDiameter * 1.5),
                pickColor.view.heightAnchor.constraint(equalToConstant: .colorButtonDiameter * 1.5),
                
                ctaButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                ctaButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: ctaBottom),
                ctaButton.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8)
            ]
    }
}
