//
//  KindKit
//

#if os(macOS)

import AppKit

extension UI.View.Progress {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Progress
        typealias Content = KKProgressView

        static var reuseIdentificator: String {
            return "UI.View.Progress"
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
    override var isFlipped: Bool {
        return true
    }
    
    private var _trackLayer: CALayer
    private var _progressLayer: CALayer
    
    override init(frame: NSRect) {
        self._trackLayer = CAGradientLayer()
        self._trackLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self._trackLayer.masksToBounds = true
        
        self._progressLayer = CAGradientLayer()
        self._progressLayer.frame = CGRect(x: 0, y: 0, width: 0, height: frame.height)
        self._trackLayer.insertSublayer(self._progressLayer, at: 0)
        
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
        
        self.layer?.insertSublayer(self._trackLayer, at: 0)
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
        self._trackLayer.frame = bounds
        if size.width > 0 && size.height > 0 {
            self._trackLayer.cornerRadius = ceil(min(size.width - 1, size.height - 1)) * 0.5
        } else {
            self._trackLayer.cornerRadius = 0
        }
        self._progressLayer.frame = CGRect(x: 0, y: 0, width: bounds.width * self.kkProgress, height: bounds.height)
    }
    
}

extension KKProgressView {
    
    func update(view: UI.View.Progress) {
        self.update(progressColor: view.progressColor)
        self.update(trackColor: view.trackColor)
        self.update(progress: view.progress)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(progressColor: UI.Color?) {
        self._progressLayer.backgroundColor = progressColor?.cgColor
    }
    
    func update(trackColor: UI.Color?) {
        self._trackLayer.backgroundColor = trackColor?.cgColor
    }
    
    func update(progress: Float) {
        self.kkProgress = progress.cgFloat
    }
    
    func update(color: UI.Color?) {
        guard let layer = self.layer else { return }
        layer.backgroundColor = color?.native.cgColor
    }
    
    func update(alpha: Float) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
