//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Control {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Control
        typealias Content = KKControlView

        static var reuseIdentificator: String {
            return "UI.View.Control"
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

final class KKControlView : UIControl {
        
    unowned var kkDelegate: KKControlViewDelegate?
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
    
    private unowned var _view: UI.View.Control?
    private var _layoutManager: UI.Layout.Manager!
    private var _isLayout: Bool
    
    override init(frame: CGRect) {
        self._isLayout = false
        
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(self._handleHighlighting(_:)), for: .touchDown)
        self.addTarget(self, action: #selector(self._handleHighlighting(_:)), for: .touchDragEnter)
        self.addTarget(self, action: #selector(self._handleUnhighlighting(_:)), for: .touchDragExit)
        self.addTarget(self, action: #selector(self._handleUnhighlighting(_:)), for: .touchUpOutside)
        self.addTarget(self, action: #selector(self._handleUnhighlighting(_:)), for: .touchCancel)
        self.addTarget(self, action: #selector(self._handlePressed(_:)), for: .touchUpInside)
        self.clipsToBounds = true
        
        self._layoutManager = UI.Layout.Manager(contentView: self, delegate: self)
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
            self._layoutManager.layout(bounds: bounds)
            self._layoutManager.visible(bounds: bounds)
        })
    }
    
}

extension KKControlView {
    
    func update(view: UI.View.Control) {
        self._view = view
        self.update(content: view.content)
        self.update(locked: view.isLocked)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
        self.kkDelegate = view
    }
    
    func update(content: IUILayout) {
        self._layoutManager.layout = content
        self.setNeedsLayout()
    }
    
    func cleanup() {
        self._layoutManager.layout = nil
        self.kkDelegate = nil
        self._view = nil
    }
    
}

private extension KKControlView {
    
    func _safeLayout(_ action: () -> Void) {
        if self._isLayout == false {
            self._isLayout = true
            action()
            self._isLayout = false
        }
    }
    
    @objc
    func _handleHighlighting(_ sender: Any) {
        if self.kkDelegate?.shouldHighlighting(self) == true {
            self.kkDelegate?.set(self, highlighted: true)
        }
    }
    
    @objc
    func _handleUnhighlighting(_ sender: Any) {
        if self.kkDelegate?.shouldHighlighting(self) == true {
            self.kkDelegate?.set(self, highlighted: false)
        }
    }
    
    @objc
    func _handlePressed(_ sender: Any) {
        if self.kkDelegate?.shouldPressing(self) == true {
            self.kkDelegate?.pressed(self)
        }
        if self.kkDelegate?.shouldHighlighting(self) == true {
            self.kkDelegate?.set(self, highlighted: false)
        }
    }
    
}

extension KKControlView : IUILayoutDelegate {
    
    func setNeedUpdate(_ appearedLayout: IUILayout) -> Bool {
        self.setNeedsLayout()
        return true
    }
    
    func updateIfNeeded(_ appearedLayout: IUILayout) {
        self.layoutIfNeeded()
    }
    
}

#endif
