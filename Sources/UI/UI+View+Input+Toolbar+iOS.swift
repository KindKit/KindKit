//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Input.Toolbar {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Input.Toolbar
        typealias Content = KKInputToolbarView

        static var reuseIdentificator: String {
            return "InputToolbarView"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: CGRect(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 44
            ))
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class KKInputToolbarView : UIToolbar {
    
    private var kkDelegate: KKInputToolbarViewDelegate?
    
    private unowned var _view: UI.View.Input.Toolbar?
            
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.clipsToBounds = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKInputToolbarView {
    
    func update(view: UI.View.Input.Toolbar) {
        self._view = view
        self.update(items: view.items)
        self.update(size: view.size)
        self.update(translucent: view.isTranslucent)
        self.update(barTintColor: view.barTintColor)
        self.update(contentTintColor: view.contentTintColor)
        self.kk_update(color: view.color)
        self.kkDelegate = view
    }
    
    func update(items: [IInputToolbarItem]) {
        let barItems = items.map({ $0.barItem })
        for barItem in barItems {
            barItem.target = self
            barItem.action = #selector(self._pressed(_:))
        }
        self.items = barItems
    }
    
    func update(size: Float) {
        self.frame = CGRect(
            origin: frame.origin,
            size: CGSize(
                width: frame.width,
                height: CGFloat(size)
            )
        )
    }
    
    func update(translucent: Bool) {
        self.isTranslucent = translucent
    }
    
    func update(barTintColor: UI.Color?) {
        self.barTintColor = barTintColor?.native
    }
    
    func update(contentTintColor: UI.Color) {
        self.tintColor = contentTintColor.native
    }
    
    func cleanup() {
        self.kkDelegate = nil
        self._view = nil
    }
    
}

private extension KKInputToolbarView {
    
    @objc
    func _pressed(_ sender: UIBarButtonItem) {
        self.kkDelegate?.pressed(self, barItem: sender)
    }
    
}

#endif
