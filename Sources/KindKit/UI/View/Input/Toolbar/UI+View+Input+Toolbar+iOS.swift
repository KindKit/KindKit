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
            return "UI.View.Input.Toolbar"
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
    
    weak var kkDelegate: KKInputToolbarViewDelegate?
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        self.backgroundColor = .clear
        self.isTranslucent = true
        self.clipsToBounds = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKInputToolbarView {
    
    func update(view: UI.View.Input.Toolbar) {
        self.update(items: view.items)
        self.update(size: view.size)
        self.update(tintColor: view.tintColor)
        self.kkDelegate = view
    }
    
    func update(items: [IUIViewInputToolbarItem]) {
        let barItems = items.map({ $0.barItem })
        for barItem in barItems {
            barItem.target = self
            barItem.action = #selector(self._pressed(_:))
        }
        self.items = barItems
    }
    
    func update(size: Double) {
        let bounds = self.bounds
        self.frame = CGRect(
            origin: bounds.origin,
            size: CGSize(
                width: bounds.width,
                height: CGFloat(size)
            )
        )
    }
    
    func update(tintColor: UI.Color?) {
        self.tintColor = tintColor?.native
    }
    
    func cleanup() {
        self.kkDelegate = nil
    }
    
}

private extension KKInputToolbarView {
    
    @objc
    func _pressed(_ sender: UIBarButtonItem) {
        self.kkDelegate?.pressed(self, barItem: sender)
    }
    
}

#endif
