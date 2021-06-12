//  © 2021 Ryan Ferrell. github.com/importRyan

import UIKit
import Combine

final class CameraPermissionsFailedVC: UIViewController {
    
    private lazy var scroll = FadeScrollView()
    private lazy var scrollContent = UIView()
    private lazy var stackView = UIStackView()
    
    private lazy var instruction = TropicalHeadline(alpha: 1, text: "Privacy")
    private lazy var explanation = TropicalExplanation(
        alpha: 1,
        text: """
This app does not collect anything about you. Filtering your camera feed is the only thing it can do.
Camera shy? According to Siri, you're looking good today.
Toggle camera access in Settings > Privacy > WCAG Shades.
""", lineHeightMultiple: 1.1)
    
    private lazy var openSettings: UIButton = {
        let b = UIButton()
        b.setTitle("Open privacy settings", for: .normal)
        b.addTarget(self, action: #selector(openPhoneSettings), for: .touchUpInside)
        b.setTitleColor(.lightGray, for: .normal)
        b.titleLabel?.font = FontNames.itim.dynamic(style: .title1)
        return b
    }()
    
    private var permissionsMonitor: AnyCancellable? = nil
    
    init() { super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError() }
    
    private lazy var constraintsPortrait = makeConstraintsPortrait()
    
}

// MARK: - Intents

extension CameraPermissionsFailedVC: AVPermissionsDelegate{
    
    @objc func openPhoneSettings() {
        let url = URL(string: UIApplication.openSettingsURLString)!
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:]) { _ in
        }
    }
    
    func cameraPermissionsDenied() {
        
    }
    
    func cameraPermissionsAccepted() {
        navigationController?.pushViewController(CameraScreenVC(filter: appDelegate().state.filter), animated: true)
        appDelegate().state.markOnboardingCompleted()
    }
    
    func monitorForAcceptance() {
        permissionsMonitor = notifyPermissionsStateChangeOnReopen()
    }
    
}

// MARK: - Setup

extension CameraPermissionsFailedVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.VeryDarkPurpleBackground.ui
        view.addSubview(scroll)
        
        scroll.addSubview(scrollContent)
        scrollContent.addSubview(stackView)
        
        instruction.textColor = Colors.SunBright.ui
        instruction.textAlignment = .left
        
        explanation.textColor = Colors.SunBright.ui
        explanation.textAlignment = .left
        explanation.font = FontNames.itim.dynamic(style: .title2)
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 22
        
        stackView.addArrangedSubview(instruction)
        stackView.addArrangedSubview(explanation)
        stackView.addArrangedSubview(openSettings)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NSLayoutConstraint.activate(constraintsPortrait)
        monitorForAcceptance()
    }
    
    private func makeConstraintsPortrait() -> [NSLayoutConstraint] {
        [scroll, scrollContent, stackView, openSettings, explanation]
            .forEach { $0?.translatesAutoresizingMaskIntoConstraints = false }
        
        return .pinning(scrollContent, to: scroll)
            + .pinning(scroll, to: view) + [
                
                scrollContent.widthAnchor.constraint(equalTo: scroll.widthAnchor),
                stackView.widthAnchor.constraint(equalTo: scrollContent.widthAnchor, multiplier: 0.8),
                stackView.centerXAnchor.constraint(equalTo: scrollContent.centerXAnchor),
                stackView.topAnchor.constraint(equalTo: scrollContent.topAnchor, constant: 40),
                stackView.bottomAnchor.constraint(equalTo: scrollContent.bottomAnchor, constant: -40)
            ]
    }
    
}
