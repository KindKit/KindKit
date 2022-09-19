//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.External {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.External
        typealias Content = KKExternalView

        static var reuseIdentificator: String {
            return "UI.View.External"
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

final class KKExternalView : UIView {
    
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
    var external: UIView? {
        willSet {
            self.external?.removeFromSuperview()
        }
        didSet {
            guard let external = self.external else { return }
            self.addSubview(external)
        }
    }
    
    private unowned var _view: UI.View.External?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let external = self.external {
            let bounds = self.bounds
            let externalBounds = external.bounds
            external.frame = CGRect(
                x: (bounds.origin.x + (bounds.size.width / 2)) - (externalBounds.size.width / 2),
                y: (bounds.origin.y + (bounds.size.height / 2)) - (externalBounds.size.height / 2),
                width: externalBounds.size.width,
                height: externalBounds.size.height
            )
        }
    }
    
}

extension KKExternalView {
    
    func update(view: UI.View.External) {
        self._view = view
        self.update(external: view.external)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
    }
    
    func update(external: UIView) {
        self.external = external
    }
    
    func cleanup() {
        self.external = nil
        self._view = nil
    }
    
}

#endif
