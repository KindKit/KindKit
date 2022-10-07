//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Segmented {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Segmented
        typealias Content = KKSegmentedView

        static var reuseIdentificator: String {
            return "UI.View.Segmented"
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

final class KKSegmentedView : UISegmentedControl {
    
    unowned var kkDelegate: KKSegmentedViewDelegate?
    
    override var frame: CGRect {
        set {
            guard super.frame != newValue else { return }
            super.frame = newValue
            if let view = self._view {
                self.kk_update(cornerRadius: view.cornerRadius)
                self.kk_updateShadowPath()
            }
        }
        get { super.frame }
    }
    var items: [UI.View.Segmented.Item] = [] {
        willSet {
            self.removeAllSegments()
        }
        didSet {
            for item in self.items {
                switch item {
                case .string(let string): self.insertSegment(withTitle: string, at: self.numberOfSegments, animated: false)
                case .image(let image): self.insertSegment(with: image.native, at: self.numberOfSegments, animated: false)
                }
            }
        }
    }
    
    private unowned var _view: UI.View.Segmented?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.clipsToBounds = true
        
        self.addTarget(self, action: #selector(self._changed(_:)), for: .valueChanged)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKSegmentedView {
    
    func update(view: UI.View.Segmented) {
        self._view = view
        self.update(items: view.items)
        self.update(selected: view.selected)
        self.update(locked: view.isLocked)
        self.kk_update(color: view.color)
        self.kk_update(border: view.border)
        self.kk_update(cornerRadius: view.cornerRadius)
        self.kk_update(shadow: view.shadow)
        self.kk_update(alpha: view.alpha)
        self.kk_updateShadowPath()
        self.kkDelegate = view
    }
    
    func update(locked: Bool) {
        self.isEnabled = locked == false
    }
    
    func update(items: [UI.View.Segmented.Item]) {
        self.items = items
    }
    
    func update(selected: UI.View.Segmented.Item?) {
        if let selected = selected {
            if let index = self.items.firstIndex(of: selected) {
                self._update(selected: index)
            } else {
                self._update(selected: Self.noSegment)
            }
        } else {
            self._update(selected: Self.noSegment)
        }
    }
    
    func cleanup() {
        self.kkDelegate = nil
        self._view = nil
    }
    
}

private extension KKSegmentedView {
    
    func _update(selected: Int) {
        if self.superview == nil {
            UIView.performWithoutAnimation({
                self.selectedSegmentIndex = selected
                self.layoutIfNeeded()
            })
        } else {
            self.selectedSegmentIndex = selected
        }
    }
    
    @objc
    func _changed(_ sender: Any) {
        self.kkDelegate?.selected(self, index: self.selectedSegmentIndex)
    }
    
}

#endif
