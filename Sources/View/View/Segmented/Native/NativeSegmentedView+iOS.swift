//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

extension SegmentedView {
    
    struct Reusable : IReusable {
        
        typealias Owner = SegmentedView
        typealias Content = NativeSegmentedView

        static var reuseIdentificator: String {
            return "SegmentedView"
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

final class NativeSegmentedView : UISegmentedControl {
    
    unowned var customDelegate: SegmentedViewDelegate?
    
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
    
    private unowned var _view: SegmentedView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.clipsToBounds = true
        
        self.addTarget(self, action: #selector(self._changed(_:)), for: .valueChanged)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NativeSegmentedView {
    
    func update(view: SegmentedView) {
        self._view = view
        self.update(items: view.items)
        self.update(items: view.items, selectedItem: view.selectedItem)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
        self.customDelegate = view
    }
    
    func update(items: [SegmentedViewItem]) {
        self.removeAllSegments()
        for item in items {
            switch item.content {
            case .string(let string): self.insertSegment(withTitle: string, at: self.numberOfSegments - 1, animated: false)
            case .image(let image): self.insertSegment(with: image.native, at: self.numberOfSegments - 1, animated: false)
            }
        }
    }
    
    func update(items: [SegmentedViewItem], selectedItem: SegmentedViewItem?) {
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
        self.customDelegate = nil
        self._view = nil
    }
    
}

private extension NativeSegmentedView {
    
    @objc
    func _changed(_ sender: Any) {
        // self.customDelegate?.changed(value: Float(self._stepper.value))
    }
    
}

#endif
