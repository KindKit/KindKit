//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

extension CustomView {
    
    struct Reusable : IReusable {
        
        typealias Owner = CustomView
        typealias Content = NativeCustomView

        static var reuseIdentificator: String {
            return "CustomView"
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

final class NativeCustomView : UIView {
    
    typealias View = IView & IViewCornerRadiusable & IViewShadowable
    
    unowned var customDelegate: NativeCustomViewDelegate?
    var contentSize: SizeFloat {
        return self._layoutManager.size
    }
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
    
    private unowned var _view: View?
    private var _layoutManager: LayoutManager!
    private var _gestures: [IGesture]
    private var _isLayout: Bool
    
    override init(frame: CGRect) {
        self._gestures = []
        self._isLayout = false
        
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        self._layoutManager = LayoutManager(contentView: self, delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willMove(toSuperview superview: UIView?) {
        super.willMove(toSuperview: superview)
        
        if superview == nil {
            self._layoutManager.clear()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self._safeLayout({
            let bounds = RectFloat(self.bounds)
            self._layoutManager.layout(bounds:bounds)
            self._layoutManager.visible(bounds: bounds)
        })
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView === self {
            let shouldHighlighting = self.customDelegate?.shouldHighlighting(view: self)
            let shouldGestures = self._gestures.contains(where: { $0.isEnabled == true })
            if shouldHighlighting == false && shouldGestures == false {
                return nil
            }
        }
        return hitView
    }
    
    override func touchesBegan(_ touches: Set< UITouch >, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if self.customDelegate?.shouldHighlighting(view: self) == true {
            self.customDelegate?.set(view: self, highlighted: true)
        }
    }
    
    override func touchesEnded(_ touches: Set< UITouch >, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if self.customDelegate?.shouldHighlighting(view: self) == true {
            self.customDelegate?.set(view: self, highlighted: false)
        }
    }
    
    override func touchesCancelled(_ touches: Set< UITouch >, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if self.customDelegate?.shouldHighlighting(view: self) == true {
            self.customDelegate?.set(view: self, highlighted: false)
        }
    }

}

extension NativeCustomView {
    
    func update< Layout : ILayout >(view: CustomView< Layout >) {
        self._view = view
        self.update(gestures: view.gestures)
        self.update(contentLayout: view.contentLayout)
        self.update(locked: view.isLocked)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
        self.customDelegate = view
    }
    
    func update(gestures: [IGesture]) {
        for gesture in self._gestures {
            self.removeGestureRecognizer(gesture.native)
        }
        self._gestures = gestures
        for gesture in self._gestures {
            self.addGestureRecognizer(gesture.native)
        }
    }
    
    func update(contentLayout: ILayout) {
        self._layoutManager.layout = contentLayout
        self.setNeedsLayout()
    }
    
    func cleanup() {
        self._layoutManager.layout = nil
        for gesture in self._gestures {
            self.removeGestureRecognizer(gesture.native)
        }
        self._gestures.removeAll()
        self.customDelegate = nil
        self._view = nil
    }
    
    func add(gesture: IGesture) {
        if self._gestures.contains(where: { $0 === gesture }) == false {
            self._gestures.append(gesture)
        }
        self.addGestureRecognizer(gesture.native)
    }
    
    func remove(gesture: IGesture) {
        if let index = self._gestures.firstIndex(where: { $0 === gesture }) {
            self._gestures.remove(at: index)
        }
        self.removeGestureRecognizer(gesture.native)
    }
    
}

private extension NativeCustomView {
    
    func _safeLayout(_ action: () -> Void) {
        if self._isLayout == false {
            self._isLayout = true
            action()
            self._isLayout = false
        }
    }
    
}

extension NativeCustomView : ILayoutDelegate {
    
    func setNeedUpdate(_ layout: ILayout) -> Bool {
        self.setNeedsLayout()
        return true
    }
    
    func updateIfNeeded(_ layout: ILayout) {
        self.layoutIfNeeded()
    }
    
}

#endif
