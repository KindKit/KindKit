//
//  KindKit
//

#if os(macOS)

import AppKit

extension UI.View.Gradient {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Gradient
        typealias Content = KKGradientView

        static var reuseIdentificator: String {
            return "UI.View.Gradient"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: .zero)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class KKGradientView : NSView {
        
    override var isFlipped: Bool {
        return true
    }
    
    private var _layer: CAGradientLayer

    override init(frame: NSRect) {
        self._layer = CAGradientLayer()
        
        super.init(frame: frame)
        
        self.wantsLayer = true
        self.layer = self._layer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
}

extension KKGradientView {
    
    func update(view: UI.View.Gradient) {
        self.update(frame: view.frame)
        self.update(fill: view.fill)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(fill: UI.View.Gradient.Fill?) {
        if let fill = fill {
            switch fill.mode {
            case .axial: self._layer.type = .axial
            case .radial: self._layer.type = .radial
            }
            self._layer.colors = fill.points.map({ $0.color.cgColor })
            self._layer.locations = fill.points.map({ NSNumber(value: $0.location) })
            self._layer.startPoint = fill.start.cgPoint
            self._layer.endPoint = fill.end.cgPoint
            self._layer.isHidden = false
        } else {
            self._layer.isHidden = true
        }
    }
    
    func update(color: UI.Color?) {
        guard let layer = self.layer else { return }
        layer.backgroundColor = color?.native.cgColor
    }
    
    func update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
