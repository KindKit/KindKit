//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindMath

extension ControlView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ControlView
        typealias Content = KKControlView

        static var reuseIdentificator: String {
            return "ControlView"
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
    
    weak var kkDelegate: KKControlViewDelegate?
    var kkLayoutManager: LayoutManager!
    var kkContentSize: Size {
        return self.kkLayoutManager.size
    }
    
    override var frame: CGRect {
        didSet {
            guard self.frame != oldValue else { return }
            if self.frame.size != oldValue.size {
                if self.window != nil {
                    self.kkLayoutManager.invalidate()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        self.addTarget(self, action: #selector(self._handleHighlighting(_:)), for: .touchDown)
        self.addTarget(self, action: #selector(self._handleHighlighting(_:)), for: .touchDragEnter)
        self.addTarget(self, action: #selector(self._handleUnhighlighting(_:)), for: .touchDragExit)
        self.addTarget(self, action: #selector(self._handleUnhighlighting(_:)), for: .touchUpOutside)
        self.addTarget(self, action: #selector(self._handleUnhighlighting(_:)), for: .touchCancel)
        self.addTarget(self, action: #selector(self._handlePressed(_:)), for: .touchUpInside)
        
        self.kkLayoutManager = .init(
            delegate: self,
            view: self
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willMove(toSuperview superview: UIView?) {
        super.willMove(toSuperview: superview)
        
        if superview == nil {
            self.kkLayoutManager.clear()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.kkLayoutManager.visibleFrame = .init(self.bounds)
        self.kkLayoutManager.updateIfNeeded()
    }
    
}

extension KKControlView {
    
    func update(view: ControlView) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(content: view.content)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.update(locked: view.isLocked)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(content: ILayout?) {
        self.kkLayoutManager.layout = content
        self.setNeedsLayout()
    }
    
    func update(color: Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func update(locked: Bool) {
        self.isUserInteractionEnabled = locked == false
    }
    
    func cleanup() {
        self.kkLayoutManager.layout = nil
        self.kkDelegate = nil
    }
    
}

private extension KKControlView {
    
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

extension KKControlView : ILayoutDelegate {
    
    func setNeedUpdate(_ appearedLayout: ILayout) -> Bool {
        guard let delegate = self.kkDelegate else { return false }
        defer {
            self.setNeedsLayout()
        }
        guard delegate.isDynamic(self) == true else {
            self.kkLayoutManager.setNeed(layout: true)
            return false
        }
        self.kkLayoutManager.setNeed(layout: true)
        return true
    }
    
    func updateIfNeeded(_ appearedLayout: ILayout) {
        self.layoutIfNeeded()
    }
    
}

#endif
