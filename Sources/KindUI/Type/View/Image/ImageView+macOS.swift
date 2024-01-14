//
//  KindKit
//

#if os(macOS)

import AppKit
import KindGraphics
import KindMath

extension ImageView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ImageView
        typealias Content = KKImageView

        static var reuseIdentificator: String {
            return "ImageView"
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

final class KKImageView : NSImageView {
    
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

extension KKImageView {
    
    func update(view: ImageView) {
        self.update(frame: view.frame)
        self.update(image: view.image)
        self.update(mode: view.mode)
        self.update(tintColor: view.tintColor)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(image: Image?) {
        self.image = image?.native
    }
    
    func update(mode: ImageView.Mode) {
        switch mode {
        case .origin: self.imageScaling = .scaleNone
        case .aspectFit: self.imageScaling = .scaleProportionallyDown
        case .aspectFill: self.imageScaling = .scaleProportionallyUpOrDown
        }
    }
    
    func update(tintColor: Color?) {
        self.contentTintColor = tintColor?.native
    }
    
    func update(color: Color?) {
        guard let layer = self.layer else { return }
        layer.backgroundColor = color?.native.cgColor
    }
    
    func update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func cleanup() {
        self.image = nil
    }
    
}

#endif
