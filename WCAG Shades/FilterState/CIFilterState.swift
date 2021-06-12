//  © 2021 Ryan Ferrell. github.com/importRyan

import UIKit
import Combine
import simd

public final class CIFilterState {
    
    // MARK: - Color Vision
    
    var vision: CIFilter? = nil
    var visionSimulation: CurrentValueSubject<ColorVision,Never>
    
    // MARK: - Color & WCAG
    
    public var wcag: CIFilter? = nil
    public private(set) var thresholdWCAG: WCAGThreshold
    public var comparatorColor: CurrentValueSubject<UIColor,Never>
    internal var comparator = CIVector(x: 1, y: 1, z: 1) // white
    internal var comparatorRelativeLuminance = Float(2.56) // white
    
    // MARK: - Setup
    
    private let queue = DispatchQueue(label: "FilterState", qos: .userInteractive)
    private var subs = Set<AnyCancellable>()
    
    init(startingColor: UIColor,
         startingThreshold: WCAGThreshold = .meaningfulColors,
         startingVision: ColorVision = .typicalTrichromacy) {
        
        self.visionSimulation = CurrentValueSubject<ColorVision,Never>(startingVision)
        
        self.comparator = Self.getUIColorComponents(startingColor)
        self.comparatorRelativeLuminance = Self.getRelativeLuminance(comparator)
        self.thresholdWCAG = startingThreshold
        self.comparatorColor = CurrentValueSubject<UIColor,Never>(startingColor)
        
        FilterVendor.registerFilters()
        self.wcag = makeWCAGFilter()
        updateFilterWithNewColors()
        updateVisionFilter()
    }
}

// MARK: - Intents

extension CIFilterState: FilterState {
    
    func setThreshold(_ new: WCAGThreshold) {
        thresholdWCAG = new // legal range of WCAG contrast ratios
        wcag = makeWCAGFilter()
    }
}

extension CIFilterState: WCAGFilterManagement {
    
    private func updateFilterWithNewColors() {
        comparatorColor
            .receive(on: queue)
            .debounce(for: .milliseconds(200), scheduler: queue)
            .sink { [weak self] color in
                guard let self = self else { return }
                self.comparator = Self.getUIColorComponents(color)
                self.comparatorRelativeLuminance = Self.getRelativeLuminance(self.comparator)
                self.wcag = self.makeWCAGFilter()
            }
            .store(in: &subs)
    }
}

extension CIFilterState: VisionFilterManagement {
    
    private func updateVisionFilter() {
        visionSimulation
            .receive(on: queue)
            .debounce(for: .milliseconds(200), scheduler: queue)
            .sink { [weak self] vision in
                guard let self = self else { return }
                self.vision = self.makeFilter(vision: vision)
            }
            .store(in: &subs)
    }
}
