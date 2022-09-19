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
        self.update(items: view.items, selectedItem: view.selectedItem)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
        self.kkDelegate = view
    }
    
    func update(items: [UI.View.Segmented.Item]) {
        self.removeAllSegments()
        for item in items {
            switch item {
            case .string(let string): self.insertSegment(withTitle: string, at: self.numberOfSegments - 1, animated: false)
            case .image(let image): self.insertSegment(with: image.native, at: self.numberOfSegments - 1, animated: false)
            }
        }
    }
    
    func update(items: [UI.View.Segmented.Item], selectedItem: UI.View.Segmented.Item?) {
        if let selectedItem = selectedItem {
            if let index = items.firstIndex(of: selectedItem) {
                self.selectedSegmentIndex = index
            } else {
                self.selectedSegmentIndex = Self.noSegment
            }
        } else {
            self.selectedSegmentIndex = Self.noSegment
        }
    }
    
    func cleanup() {
        self.kkDelegate = nil
        self._view = nil
    }
    
}

private extension KKSegmentedView {
    
    @objc
    func _changed(_ sender: Any) {
        self.kkDelegate?.selected(self, index: self.selectedSegmentIndex)
    }
    
}

#endif
