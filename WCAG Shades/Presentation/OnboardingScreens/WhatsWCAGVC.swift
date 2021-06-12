//  © 2021 Ryan Ferrell. github.com/importRyan

import UIKit

final class WhatsWCAGVC: UIViewController {
    
    private lazy var scroll = FadeScrollView()
    private lazy var scrollContent = UIView()
    private lazy var stackView = UIStackView()
    
    private lazy var instruction = TropicalHeadline(alpha: 1, text: "What? ")
    private lazy var explanation = TropicalExplanation(alpha: 1,
                                                       text: makeExplanationString(),
                                                       lineHeightMultiple: 1.1)
    
    private lazy var learn: UIButton = makeLearnButton()
    
    private lazy var closeButton: UIButton = {
        let b = CloseButton(tint: Colors.DarkPurpleHeadline.ui)
        b.addTarget(self, action: #selector(closeSheet), for: .touchUpInside)
        return b
    }()
    
    init() { super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError() }
    
    private lazy var constraintsPortrait = makeConstraintsPortrait()
    
}


// MARK: - Intents

extension WhatsWCAGVC {
    
    @objc func closeSheet() {
        dismiss(animated: true) {
        }
    }
    
    @objc func learnMore() {
        let url = URL(string: "https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html")!
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: - Setup

extension WhatsWCAGVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.SunBright.ui
        view.addSubview(scroll)
        
        scroll.addSubview(scrollContent)
        scrollContent.addSubview(stackView)
        
        instruction.textColor = Colors.DarkPurpleHeadline.ui
        instruction.textAlignment = .left
        
        explanation.textColor = Colors.DarkPurpleHeadline.ui
        explanation.textAlignment = .left
        explanation.font = FontNames.itim.dynamic(style: .title1)
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 22
        
        stackView.addArrangedSubview(instruction)
        stackView.addArrangedSubview(explanation)
        stackView.addArrangedSubview(learn)
        
        view.addSubview(closeButton)
        
        [scroll, scrollContent, stackView, learn, explanation, closeButton]
            .forEach { $0?.translatesAutoresizingMaskIntoConstraints = false }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NSLayoutConstraint.activate(constraintsPortrait)
    }
    
}

private extension WhatsWCAGVC {
    
    func makeLearnButton() -> UIButton {
        let b = UIButton()
        b.setTitle("Learn more...", for: .normal)
        b.addTarget(self, action: #selector(learnMore), for: .touchUpInside)
        b.setTitleColor(Colors.PinkLink.ui, for: .normal)
        b.titleLabel?.font = FontNames.itim.dynamic(style: .title1)
        return b
    }
    
    func makeExplanationString() -> String {
        """
Apple recommends developers follow the Web Content Accessibility Group' guidelines for inclusive design.
Some guidelines relate to color contrast, specifically the minimum ratios between text, backgrounds, and meaningful symbols.
WCAG defines a color contrast ratio as a grayscale comparison of two colors relative luminance. The ratio is non-linear, with a minimum of 1 and maximum of 21 (black vs. white). Passing scores for standards range from 3 to 7.
You can pronounce WCAG how you like. Some say it as one word, starting like... damn, those are some wicked shades.
WCAG's heuristic is useful, but it ain't perfect. Even if a combination passes, use judgement. Groups like the Alzheimer's Society provide great design guidelines to make apps work better for people as they age.
"""
    }
    
    func makeConstraintsPortrait() -> [NSLayoutConstraint] {

        return .pinning(scrollContent, to: scroll)
            + .pinning(scroll, to: view) + [
                
                closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
                closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
                closeButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
                closeButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
                
                
                scrollContent.widthAnchor.constraint(equalTo: scroll.widthAnchor),
                
                stackView.widthAnchor.constraint(equalTo: scrollContent.widthAnchor, multiplier: 0.8),
                stackView.centerXAnchor.constraint(equalTo: scrollContent.centerXAnchor, constant: scrollContent.frame.size.width * 0.1),
                stackView.topAnchor.constraint(equalTo: scrollContent.topAnchor, constant: 40),
                stackView.bottomAnchor.constraint(equalTo: scrollContent.bottomAnchor, constant: -40)
            ]
    }
}
