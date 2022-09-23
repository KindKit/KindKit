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
    var content: UIView? {
        willSet {
            self.content?.removeFromSuperview()
        }
        didSet {
            guard let content = self.content else { return }
            self.addSubview(content)
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
        
        if let content = self.content {
            let bounds = self.bounds
            let contentBounds = content.bounds
            content.frame = CGRect(
                x: (bounds.origin.x + (bounds.size.width / 2)) - (contentBounds.size.width / 2),
                y: (bounds.origin.y + (bounds.size.height / 2)) - (contentBounds.size.height / 2),
                width: contentBounds.size.width,
                height: contentBounds.size.height
            )
        }
    }
    
}

extension KKExternalView {
    
    func update(view: UI.View.External) {
        self._view = view
        self.update(content: view.content)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
    }
    
    func update(content: UIView) {
        self.content = content
    }
    
    func cleanup() {
        self.content = nil
        self._view = nil
    }
    
}

#endif
