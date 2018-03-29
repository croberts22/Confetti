//
//  ConfettiView.swift
//  ConfettiView
//
//  Created by Corey Roberts on 2/27/18.
//
//

import UIKit
import QuartzCore


/// A class that emits fun confetti. 🎊
public final class ConfettiView: UIView {
    
    
    /// An enum describing the types of confetti that can rain.
    ///
    /// - confetti: Standard confetti.
    /// - tacos: Tacos!
    /// - image: A custom image.
    public enum ConfettiType {
        case confetti
        case taco
        case image(UIImage)
        
        
        var colorSet: [UIColor]? {
            switch self {
            case .confetti:
                return [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
                        UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
                        UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
                        UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
                        UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]
            case .taco:
                return [UIColor.white,
                        UIColor.white,
                        UIColor.white]
            case .image(_):
                // Default value.
                return [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
                        UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
                        UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
                        UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
                        UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]
            }
        }
        
        
        var image: UIImage {
            switch self {
            case .confetti:
                return #imageLiteral(resourceName: "confetti")
            case .taco:
                return #imageLiteral(resourceName: "taco")
            case let .image(customImage):
                return customImage
            }
        }
    }
    
    
    public var intensity: Float = 0.75
    public var type: ConfettiType = .confetti
    
    private(set) var isActive: Bool = false
    
    private lazy var emitter: CAEmitterLayer = CAEmitterLayer()
    
    
    // MARK: - Public Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Starts the confetti! 🎊
    public func start(withDelay delay: Double = 0.0) {
        
        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
        emitter.emitterCells = confetti()
        
        let startAction: () -> () = {
            self.layer.addSublayer(self.emitter)
            self.isActive = true
        }
        
        if delay > 0.0 {
            let time = DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds) + Double(1 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time) {
                startAction()
            }
        }
        else {
            startAction()
        }
    }
    
    /// Stops the confetti. 😔
    public func stop() {
        
        UIView.animate(withDuration: 0.3) {
            self.emitter.birthRate = 0
        }
        
        isActive = false
    }
    
    
    // MARK: - Private Methods
    
    /// Creates an array of emitter cells based on the current confetti configured.
    ///
    /// - Returns: An array of confetti emitter cells.
    fileprivate func confetti() -> [CAEmitterCell] {
        return confetti(for: type)
    }
    
    
    /// Creates an array of emitter cells based on a confetti type.
    ///
    /// - Parameter type: A confetti type.
    /// - Returns: An array of confetti emitter cells.
    fileprivate func confetti(for type: ConfettiType) -> [CAEmitterCell] {
        
        var cells: [CAEmitterCell] = [CAEmitterCell]()
        
        if let colorSet = type.colorSet {
            // Iterate through each color and create a new emitter.
            cells.append(contentsOf: colorSet.map { confetti(for: type, withColor: $0) })
        }
        else {
            // If no color set is defined, default to white.
            cells.append(confetti(for: type, withColor: .white))
        }
        
        return cells
    }
    
    
    /// Creates an emitter based on a type and colorl
    ///
    /// - Parameters:
    ///   - type: A confetti type.
    ///   - color: A color. Defaults to white (no color).
    /// - Returns: A confetti emitter cell.
    fileprivate func confetti(for type: ConfettiType, withColor color: UIColor = .white) -> CAEmitterCell {
        
        let confetti = CAEmitterCell()
        
        confetti.birthRate = 6.0 * intensity
        confetti.lifetime = 14.0 * intensity
        confetti.lifetimeRange = 0
        confetti.velocity = CGFloat(350.0 * intensity)
        confetti.velocityRange = CGFloat(80.0 * intensity)
        confetti.emissionLongitude = CGFloat(Double.pi)
        confetti.emissionRange = CGFloat(Double.pi / 4.0)
        confetti.spin = CGFloat(3.5 * intensity)
        confetti.spinRange = CGFloat(4.0 * intensity)
        confetti.scaleRange = CGFloat(intensity)
        confetti.scaleSpeed = CGFloat(-0.1 * intensity)
        
        confetti.color = color.cgColor
        confetti.contents = type.image.cgImage
        
        return confetti
    }
    
}

