//
//  KindKit
//

#if os(macOS)

import AppKit

extension UI.View.Image {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Image
        typealias Content = KKImageView

        static var reuseIdentificator: String {
            return "UI.View.Image"
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
    
    unowned var kkDelegate: KKControlViewDelegate?
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
    
    private unowned var _view: UI.View.Image?
    
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

extension KKImageView {
    
    func update(view: UI.View.Image) {
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
    
    func update(image: KindKit.Image) {
        self.image = image.native
    }
    
    func update(mode: UI.View.Image.Mode) {
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
