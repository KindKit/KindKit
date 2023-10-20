//
//  KindKit
//

#if os(macOS)

import AppKit

extension UI.View.AnimatedImage {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.AnimatedImage
        typealias Content = KKAnimatedImageView

        static var reuseIdentificator: String {
            return "UI.View.AnimatedImage"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: .zero)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.kk_cleanup()
        }
        
    }
    
}

final class KKAnimatedImageView : NSImageView {
    
    var kkImages: [NSImage] = []
    var kkDuration: TimeInterval = 0
    var kkRepeat: UI.View.AnimatedImage.Repeat = .infinity
    var kkAnimation: CAKeyframeAnimation? {
        willSet {
            guard let layer = self.layer else { return }
            layer.removeAnimation(forKey: "KindKit::AnimatedImage")
        }
        didSet {
            guard let layer = self.layer, let animation = self.kkAnimation else { return }
            layer.add(animation, forKey: "KindKit::AnimatedImage")
            
        }
    }
    var kkIsAnimating: Bool {
        return self.kkAnimation != nil
    }
    
    override var isFlipped: Bool {
        return true
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        
        self.imageFrameStyle = .none
        self.imageAlignment = .alignCenter
        self.wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
}

extension KKAnimatedImageView {
    
    func kk_update(view: UI.View.AnimatedImage) {
        self.kk_update(frame: view.frame)
        self.kk_update(images: view.images)
        self.kk_update(duration: view.duration)
        self.kk_update(repeat: view.repeat)
        self.kk_update(mode: view.mode)
        self.kk_update(tintColor: view.tintColor)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
    }
    
    func kk_update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func kk_update(images: [UI.Image]) {
        self.kkImages = images.map({ $0.native })
    }
    
    func kk_update(duration: TimeInterval) {
        self.kkDuration = duration
    }
    
    func kk_update(repeat: UI.View.AnimatedImage.Repeat) {
        self.kkRepeat = `repeat`
    }
    
    func kk_update(mode: UI.View.AnimatedImage.Mode) {
        switch mode {
        case .origin: self.imageScaling = .scaleNone
        case .aspectFit: self.imageScaling = .scaleProportionallyDown
        case .aspectFill: self.imageScaling = .scaleProportionallyUpOrDown
        }
    }
    
    func kk_update(tintColor: UI.Color?) {
        self.contentTintColor = tintColor?.native
    }
    
    func kk_update(color: UI.Color?) {
        guard let layer = self.layer else { return }
        layer.backgroundColor = color?.native.cgColor
    }
    
    func kk_update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func kk_start() {
        let animation = CAKeyframeAnimation(keyPath: "contents")
        animation.calculationMode = .discrete
        animation.values = self.kkImages
        animation.duration = self.kkDuration
        switch self.kkRepeat {
        case .loops(let count):
            animation.repeatCount = Float(count)
        case .infinity:
            animation.repeatCount = .infinity
        }
        self.kkAnimation = animation
    }
    
    func kk_stop() {
        self.kkAnimation = nil
    }
    
    func kk_cleanup() {
        self.kkAnimation = nil
        self.image = nil
    }
    
}

#endif
