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
        
        static func name(owner: Owner) -> String {
            return "ImageView"
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
    
    final func kk_update(view: ImageView) {
        self.kk_update(frame: view.frame)
        self.kk_update(image: view.image)
        self.kk_update(mode: view.mode)
        self.kk_update(tintColor: view.tintColor)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
    }
    
    final func kk_cleanup(view: ImageView) {
        self.image = nil
    }
    
}

extension KKImageView {
    
    final func kk_update(image: Image?) {
        self.image = image?.native
    }
    
    final func kk_update(mode: ImageMode) {
        switch mode {
        case .origin: self.imageScaling = .scaleNone
        case .aspectFit: self.imageScaling = .scaleProportionallyDown
        case .aspectFill: self.imageScaling = .scaleProportionallyUpOrDown
        }
    }
    
    final func kk_update(tintColor: Color?) {
        self.contentTintColor = tintColor?.native
    }
    
    final func kk_update(color: Color) {
        guard let layer = self.layer else { return }
        layer.backgroundColor = color.native.cgColor
    }
    
    final func kk_update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
}

#endif
