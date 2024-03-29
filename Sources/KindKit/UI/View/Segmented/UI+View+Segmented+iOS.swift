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
    
    weak var kkDelegate: KKSegmentedViewDelegate?
    var kkPreset: UI.View.Segmented.Preset? {
        didSet {
            self.setTitleTextAttributes(self.kkPreset?.attributes, for: .normal)
        }
    }
    var kkSelectedPreset: UI.View.Segmented.Preset? {
        didSet {
            self.setTitleTextAttributes(self.kkSelectedPreset?.attributes, for: .selected)
            if #available(iOS 13.0, *) {
                self.selectedSegmentTintColor = self.kkSelectedPreset?.color?.native
            } else {
                self.tintColor = self.kkSelectedPreset?.color?.native
            }
        }
    }
    var kkItems: [UI.View.Segmented.Item] = [] {
        willSet {
            self.removeAllSegments()
        }
        didSet {
            for item in self.kkItems {
                switch item {
                case .string(let string): self.insertSegment(withTitle: string, at: self.numberOfSegments, animated: false)
                case .image(let image): self.insertSegment(with: image.native, at: self.numberOfSegments, animated: false)
                }
            }
        }
    }
    
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
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(items: view.items)
        self.update(selected: view.selected)
        self.update(preset: view.preset)
        self.update(selectedPreset: view.selectedPreset)
        self.update(locked: view.isLocked)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(items: [UI.View.Segmented.Item]) {
        self.kkItems = items
    }
    
    func update(selected: UI.View.Segmented.Item?) {
        if let selected = selected {
            if let index = self.kkItems.firstIndex(of: selected) {
                self._update(selected: index)
            } else {
                self._update(selected: Self.noSegment)
            }
        } else {
            self._update(selected: Self.noSegment)
        }
    }
    
    func update(preset: UI.View.Segmented.Preset?) {
        self.kkPreset = preset
    }
    
    func update(selectedPreset: UI.View.Segmented.Preset?) {
        self.kkSelectedPreset = selectedPreset
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func update(locked: Bool) {
        self.isEnabled = locked == false
    }
    
    func cleanup() {
        self.kkDelegate = nil
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
