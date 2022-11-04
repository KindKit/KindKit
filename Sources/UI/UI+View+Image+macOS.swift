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
    
    weak var kkDelegate: KKControlViewDelegate?
    override var isFlipped: Bool {
        return true
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
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
        self.update(image: view.image)
        self.update(mode: view.mode)
        self.update(tintColor: view.tintColor)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(image: UI.Image?) {
        self.image = image?.native
    }
    
    func update(mode: UI.View.Image.Mode) {
        switch mode {
        case .origin: self.imageScaling = .scaleNone
        case .aspectFit: self.imageScaling = .scaleProportionallyDown
        case .aspectFill: self.imageScaling = .scaleProportionallyUpOrDown
        }
    }
    
    func update(tintColor: UI.Color?) {
        self.contentTintColor = tintColor?.native
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
