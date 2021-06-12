//  © 2021 Ryan Ferrell. github.com/importRyan

import UIKit
import LinkPresentation

/// Allows async collection of share item var AFTER user picks a share destination from menu
class PhotoProvider: UIActivityItemProvider {
    
    var shareImage: UIImage
    var vision: ColorVision?
    var shareText: String {
        guard let vision = vision, vision != .typicalTrichromacy else { return "WCAG Shades" }
        return "WCAG Shades (Simulated as \(vision.name))"
    }
    

    init(_ image: UIImage, visionSim: ColorVision?) {
        self.vision = visionSim
        self.shareImage = image
        super.init(placeholderItem: image)
    }
    
    override func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let data = LPLinkMetadata()
        data.title = shareText
        data.imageProvider = .init(object: shareImage)
        return data
    }
    
    override var item: Any {
        guard let activity = activityType else { return shareImage }
    
        switch activity {
            case .saveToCameraRoll:
                return shareImage.pngData() ?? shareImage
            default: return shareImage
        }
    }
    
    override func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        shareText
    }
    

}
