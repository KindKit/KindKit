//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

extension InputToolbarView {
    
    struct Reusable : IReusable {
        
        typealias Owner = InputToolbarView
        typealias Content = NativeInputToolbarView

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

final class NativeInputToolbarView : UIToolbar {
    
    private var customDelegate: InputToolbarViewDelegate?
    
    private unowned var _view: InputToolbarView?
            
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.clipsToBounds = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NativeInputToolbarView {
    
    func update(view: InputToolbarView) {
        self._view = view
        self.update(items: view.items)
        self.update(size: view.size)
        self.update(translucent: view.isTranslucent)
        self.update(barTintColor: view.barTintColor)
        self.update(contentTintColor: view.contentTintColor)
        self.update(color: view.color)
        self.customDelegate = view
    }
    
    func update(items: [IInputToolbarItem]) {
        let barItems = items.compactMap({ return $0.barItem })
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
    
    func update(barTintColor: Color?) {
        self.barTintColor = barTintColor?.native
    }
    
    func update(contentTintColor: Color) {
        self.tintColor = contentTintColor.native
    }
    
    func cleanup() {
        self.customDelegate = nil
        self._view = nil
    }
    
}

private extension NativeInputToolbarView {
    
    @objc
    func _pressed(_ sender: UIBarButtonItem) {
        self.customDelegate?.pressed(barItem: sender)
    }
    
}

#endif
