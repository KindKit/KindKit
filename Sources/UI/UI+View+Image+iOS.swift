//
//  KindKit
//

#if os(iOS)

import UIKit

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

final class KKImageView : UIImageView {
    
    override var frame: CGRect {
        set {
            guard super.frame != newValue else { return }
            super.frame = newValue
            if let view = self._view {
                self.kk_update(cornerRadius: view.cornerRadius)
                self.kk_updateShadowPath()
            }
        }
        get { return super.frame }
    }
    
    private unowned var _view: UI.View.Image?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKImageView {
    
    func update(view: UI.View.Image) {
        self._view = view
        self.update(image: view.image)
        self.update(mode: view.mode)
        self.update(tintColor: view.tintColor)
        self.kk_update(color: view.color)
        self.kk_update(border: view.border)
        self.kk_update(cornerRadius: view.cornerRadius)
        self.kk_update(shadow: view.shadow)
        self.kk_update(alpha: view.alpha)
        self.kk_updateShadowPath()
    }
    
    func update(image: UI.Image) {
        self.image = image.native
    }
    
    func update(mode: UI.View.Image.Mode) {
        switch mode {
        case .origin: self.contentMode = .center
        case .aspectFit: self.contentMode = .scaleAspectFit
        case .aspectFill: self.contentMode = .scaleAspectFill
        }
    }
    
    func update(tintColor: UI.Color?) {
        self.tintColor = tintColor?.native
    }
    
    func cleanup() {
        self._view = nil
    }
    
}

#endif
