//
//  KindKitView
//

#if os(macOS)

import AppKit
import KindKitCore
import KindKitMath

extension ImageView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ImageView
        typealias Content = NativeImageView

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

final class NativeImageView : NSImageView {
    
    typealias View = IView & IViewCornerRadiusable & IViewShadowable
    
    unowned var customDelegate: NativeControlViewDelegate?
    override var frame: CGRect {
        set(value) {
            if super.frame != value {
                super.frame = value
                if let view = self._view {
                    self.update(cornerRadius: view.cornerRadius)
                    self.updateShadowPath()
                }
            }
        }
        get { return super.frame }
    }
    override var isFlipped: Bool {
        return true
    }
    
    private unowned var _view: View?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageFrameStyle = .none
        self.imageAlignment = .alignCenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
}

extension NativeImageView {
    
    func update(view: ImageView) {
        self._view = view
        self.update(image: view.image)
        self.update(mode: view.mode)
        self.update(color: view.color)
        self.update(tintColor: view.tintColor)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
    }
    
    func update(image: Image) {
        self.image = image.native
    }
    
    func update(mode: ImageViewMode) {
        switch mode {
        case .origin: self.imageScaling = .scaleNone
        case .aspectFit: self.imageScaling = .scaleProportionallyDown
        case .aspectFill: self.imageScaling = .scaleProportionallyUpOrDown
        }
    }
    
    func update(tintColor: Color?) {
        self.contentTintColor = tintColor?.native
    }
    
    func cleanup() {
        self._view = nil
    }
    
}

#endif
