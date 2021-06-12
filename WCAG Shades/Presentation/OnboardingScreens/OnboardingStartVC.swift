//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit
import Combine

final class OnboardingStartVC: UIViewController {
    
    private lazy var scroll = FadeScrollView()
    private lazy var scrollContent = UIView()
    private lazy var stackView = UIStackView()
    
    private lazy var shadesImage = UIImageView(image: Image.WCAGPinkShades.ui)
    
    private lazy var headline: UILabel = TropicalHeadline(alpha: 0, text: "See your world ")
    
    private lazy var subheadline = TropicalExplanation(alpha: 0,
                                                       text: "with WCAG 2.1 color contrast lenses",
                                                       lineHeightMultiple: 1.1)
    
    private lazy var whatIsWCAGButton: UIButton = makeWhatIsButton()
    private lazy var ctaButton: UIButton = makeCTAButton()
    private lazy var legal: UIButton = makeLegalButton()
    
    init() { super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError() }
    
    // Constraints
    
    private lazy var constraintsPortrait: [NSLayoutConstraint] = makePortraitConstraints()
    
    private lazy var addExtraVerticalPadding = UIDevice.current.userInterfaceIdiom == .pad && UIApplication.shared.preferredContentSizeCategory < .accessibilityExtraExtraLarge
    private lazy var scrollTopPortrait = scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: addExtraVerticalPadding ? 40 : 15)
    private lazy var scrollTopLandscape = scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: addExtraVerticalPadding ? 0 : 20)
}

// MARK: - Intents

extension OnboardingStartVC {
    
    @objc func tapCTA() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey:nil)
        navigationController?.pushViewController(SelectAColorVC(), animated: false)
    }
    
    @objc func showLegal() {
        let vc = LegalVC()
        vc.view.accessibilityViewIsModal = true
        present(vc, animated: true)
    }
    
    @objc func explainWCAG() {
        let vc = WhatsWCAGVC()
        vc.view.accessibilityViewIsModal = true
        present(vc, animated: true)
    }

    // Highlights
    
    @objc func highlightWhatIs() {
        UIView.animate(withDuration: 0.15) {
            self.whatIsWCAGButton.layer.backgroundColor = Colors.DarkPurpleHeadline.ui.cgColor
            self.whatIsWCAGButton.setTitleColor(Colors.TealBackground.ui, for: .normal)
        }
    }
    
    @objc func unhighlightWhatIs() {
        UIView.animate(withDuration: 0.2) {
            self.whatIsWCAGButton.layer.backgroundColor = UIColor.clear.cgColor
            self.whatIsWCAGButton.setTitleColor(Colors.DarkPurpleHeadline.ui, for: .normal)
        }
    }
}

// MARK: - Setup

extension OnboardingStartVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.TealBackground.ui
        
        view.addSubview(scroll)
        view.addSubview(ctaButton)
        view.addSubview(legal)
        
        scroll.addSubview(scrollContent)
        scrollContent.addSubview(stackView)
        
        configureStackView()
        if UIDevice.current.userInterfaceIdiom == .pad {
            configureForPad()
        } else { configureForPhone() }
        
        markupAccessibility()
        shadesImage.contentMode = .scaleAspectFit
        [headline, subheadline, whatIsWCAGButton].forEach { $0.transform = .init(translationX: 0, y: 20) }
        
        [scroll, scrollContent, stackView, headline, legal, ctaButton, shadesImage]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NSLayoutConstraint.activate(constraintsPortrait)
        NSLayoutConstraint.activate([UIDevice.current.orientation.isLandscape ? scrollTopLandscape : scrollTopPortrait])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        whatIsWCAGButton.layer.setNeedsLayout()
        animateAppearances()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if size.isPortrait {
            NSLayoutConstraint.deactivate([scrollTopLandscape])
            NSLayoutConstraint.activate([scrollTopPortrait])
        } else {
            NSLayoutConstraint.deactivate([scrollTopPortrait])
            NSLayoutConstraint.activate([scrollTopLandscape])
        }
    }
    

}

// MARK: - Entrance Animations

private extension OnboardingStartVC {
    
    func animateAppearances() {
        whatIsWCAGButton.alpha = 0
        ctaButton.alpha = 0
        animateRise(headline, delay: 0.1)
        animateRise(subheadline, delay: 0.3)
        animateRise(whatIsWCAGButton, delay: 0.5)
        
        UIView.animate(withDuration: 0.5, delay: 0.9, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: []) {
            self.ctaButton.alpha = 1
            self.ctaButton.transform = .identity.rotated(by: -5/57)
        }
    }
    
    
    func animateRise(_ view: UIView, delay: Double) {
        UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseOut, animations: {
            view.transform = .identity
            view.alpha = 1
            view.layoutIfNeeded()
        })
    }
}

// MARK: - Setup

private extension OnboardingStartVC {
    
    func configureForPhone() {
        stackView.alignment = .leading
        subheadline.textAlignment = .left
        headline.textAlignment = .left    }
    
    func configureForPad() {
        stackView.alignment = .center
        subheadline.textAlignment = .center
        headline.textAlignment = .center
    }
    
    func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(shadesImage)
        stackView.addArrangedSubview(headline)
        stackView.addArrangedSubview(subheadline)
        stackView.addArrangedSubview(whatIsWCAGButton)

        stackView.setCustomSpacing(40, after: subheadline)
        stackView.setCustomSpacing(UIApplication.shared.preferredContentSizeCategory > .large ? 80 : 0, after: whatIsWCAGButton)
    }
    
    func markupAccessibility() {
        shadesImage.accessibilityLabel = "Rose WCAG Shades"
    }
    
    func makeCTAButton() -> UIButton {
        let button = TropicalButton(frame: .zero, text: "Pick a Color",
                                    textColor: Colors.TealBackground.ui,
                                    horizontalInsets: 30,
                                    start: Colors.DarkPurpleHeadline.ui,
                                    end: Colors.DarkPurpleHeadline.ui)
        button.addTarget(self, action: #selector(tapCTA), for: .touchUpInside)
        return button
    }
    
    func makeLegalButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Legal", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        button.setTitleColor(.darkText, for: .normal)
        button.alpha = 0.5
        button.titleLabel?.alpha = 0.9
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.contentEdgeInsets = .init(vertical: 4, horizontal: 10)
        button.addTarget(self, action: #selector(showLegal), for: .touchUpInside)
        return button
    }
    
    func makeWhatIsButton() -> UIButton {
        let b = UIButton(type: .custom)
        b.setTitle("What's WCAG?", for: .normal)
        b.tintColor = Colors.DarkPurpleHeadline.ui

        b.titleLabel?.font = FontNames.itim.dynamic(
            style: .title2,
            adding: 4, max: 40)
        
        b.titleLabel?.lineBreakMode = .byWordWrapping
        b.titleLabel?.numberOfLines = 0
        b.titleLabel?.textAlignment = .center
        b.titleLabel?.adjustsFontForContentSizeCategory = true
        
        b.layer.borderWidth = 2
        b.layer.cornerRadius = 12
        b.layer.borderColor = Colors.DarkPurpleHeadline.ui.cgColor
        
        b.contentEdgeInsets = .init(vertical: 4, horizontal: 10)
        b.setTitleColor(Colors.DarkPurpleHeadline.ui, for: .normal)
        b.addTarget(self, action: #selector(explainWCAG), for: .touchUpInside)
        b.addTarget(self, action: #selector(highlightWhatIs), for: [.touchDown, .touchDragEnter])
        b.addTarget(self, action: #selector(unhighlightWhatIs), for: [.touchDragExit, .touchUpInside, .touchUpOutside])
        return b
    }
    
}

// MARK: - Constraints

private extension OnboardingStartVC {
    
    func makePortraitConstraints() -> [NSLayoutConstraint] {
        let maxImageDimension = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let scaleFactor: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 0.35 : 0.5

        let ctaBottom: CGFloat = UIDevice.current.userInterfaceIdiom == .pad
        ? addExtraVerticalPadding ? -90 : -70
        : view.safeAreaInsets.bottom == 0 ? -45 : -20
        
        return .pinning(scrollContent, to: scroll)
            + [
                scroll.bottomAnchor.constraint(equalTo: ctaButton.topAnchor, constant: 0),
                scroll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                scroll.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                
                scrollContent.widthAnchor.constraint(equalTo: scroll.widthAnchor),
                
                shadesImage.widthAnchor.constraint(equalToConstant: maxImageDimension * scaleFactor),
                shadesImage.heightAnchor.constraint(equalToConstant: maxImageDimension * scaleFactor),
                
                stackView.widthAnchor.constraint(equalTo: scrollContent.widthAnchor, multiplier: 0.8),
                stackView.centerXAnchor.constraint(equalTo: scrollContent.centerXAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? 0 : UIScreen.main.bounds.width * 0.07),
                stackView.topAnchor.constraint(equalTo: scrollContent.topAnchor, constant: 20),
                stackView.bottomAnchor.constraint(equalTo: scrollContent.bottomAnchor, constant: -60),
                
                ctaButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                ctaButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: ctaBottom),
                ctaButton.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.9),
                
                legal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIDevice.current.sizing == .constrained ? 20 : 20),
                legal.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: UIDevice.current.sizing == .constrained || UIDevice.current.userInterfaceIdiom == .pad ? -15 : -5),
                legal.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.9)
            ]
    }
    
    func maxExplanationWidth() -> CGFloat {
        min(250, max(scrollContent.bounds.width, 300))
    }
}
