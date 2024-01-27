//
//  KindKit
//

#if os(macOS)

import AppKit
import KindGraphics
import KindMath

extension GradientView {
    
    struct Reusable : IReusable {
        
        typealias Owner = GradientView
        typealias Content = KKGradientView
        
        static func name(owner: Owner) -> String {
            return "GradientView"
        }
        
        static func create(owner: Owner) -> Content {
            return .init(frame: .zero)
        }
        
        static func configure(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanup(owner: Owner, content: Content) {
            content.kk_cleanup(view: owner)
        }
        
    }
    
}

final class KKGradientView : NSView {
    
    let kkLayer = CAGradientLayer()
    
    override var isFlipped: Bool {
        return true
    }

    override init(frame: NSRect) {
        super.init(frame: frame)
        
        self.wantsLayer = true
        self.layer = self.kkLayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
}

extension KKGradientView {
    
    func kk_update(view: GradientView) {
        self.kk_update(frame: view.frame)
        self.kk_update(fill: view.fill)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
    }
    
    final func kk_cleanup(view: GradientView) {
    }
    
}

extension KKGradientView {
    
    func kk_update(fill: Gradient) {
        switch fill.mode {
        case .axial: self.kkLayer.type = .axial
        case .radial: self.kkLayer.type = .radial
        }
        self.kkLayer.colors = fill.points.map({ $0.color.cgColor })
        self.kkLayer.locations = fill.points.map({ NSNumber(value: $0.location) })
        self.kkLayer.startPoint = fill.start.cgPoint
        self.kkLayer.endPoint = fill.end.cgPoint
        self.kkLayer.isHidden = false
    }
    
    func kk_update(color: Color) {
        self.kkLayer.backgroundColor = color.native.cgColor
    }
    
    func kk_update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
}

#endif
