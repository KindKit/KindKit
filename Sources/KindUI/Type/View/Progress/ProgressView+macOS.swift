//
//  KindKit
//

#if os(macOS)

import AppKit
import KindGraphics
import KindMath

extension ProgressView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ProgressView
        typealias Content = KKProgressView

        static var reuseIdentificator: String {
            return "ProgressView"
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

final class KKProgressView : NSView {
    
    var kkProgress: CGFloat = 0 {
        didSet {
            guard self.kkProgress != oldValue else { return }
            self.needsLayout = true
        }
    }
    let kkTrackLayer: CALayer
    let kkProgressLayer: CALayer
    
    override var isFlipped: Bool {
        return true
    }
    
    override init(frame: NSRect) {
        self.kkTrackLayer = CAGradientLayer()
        self.kkTrackLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.kkTrackLayer.masksToBounds = true
        
        self.kkProgressLayer = CAGradientLayer()
        self.kkProgressLayer.frame = CGRect(x: 0, y: 0, width: 0, height: frame.height)
        self.kkTrackLayer.insertSublayer(self.kkProgressLayer, at: 0)
        
        super.init(frame: frame)
        
        self.wantsLayer = true
        
        self.layer?.insertSublayer(self.kkTrackLayer, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
    override func layout() {
        super.layout()
        
        let bounds = self.bounds
        
        let size = bounds.size
        self.kkTrackLayer.frame = bounds
        if size.width > 0 && size.height > 0 {
            self.kkTrackLayer.cornerRadius = ceil(min(size.width - 1, size.height - 1)) * 0.5
        } else {
            self.kkTrackLayer.cornerRadius = 0
        }
        self.kkProgressLayer.frame = CGRect(x: 0, y: 0, width: bounds.width * self.kkProgress, height: bounds.height)
    }
    
}

extension KKProgressView {
    
    func update(view: ProgressView) {
        self.update(frame: view.frame)
        self.update(progressColor: view.progressColor)
        self.update(trackColor: view.trackColor)
        self.update(progress: view.progress)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(progressColor: Color?) {
        self.kkProgressLayer.backgroundColor = progressColor?.cgColor
    }
    
    func update(trackColor: Color?) {
        self.kkTrackLayer.backgroundColor = trackColor?.cgColor
    }
    
    func update(progress: Double) {
        self.kkProgress = CGFloat(progress)
    }
    
    func update(color: Color?) {
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
