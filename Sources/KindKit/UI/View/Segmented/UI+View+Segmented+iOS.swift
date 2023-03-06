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
    
    fileprivate weak var _delegate: KKSegmentedViewDelegate?
    fileprivate var _preset: UI.View.Segmented.Preset? {
        didSet {
            self.setTitleTextAttributes(self._preset?.attributes, for: .normal)
        }
    }
    fileprivate var _selectedPreset: UI.View.Segmented.Preset? {
        didSet {
            self.setTitleTextAttributes(self._selectedPreset?.attributes, for: .selected)
            if #available(iOS 13.0, *) {
                self.selectedSegmentTintColor = self._selectedPreset?.color?.native
            } else {
                self.tintColor = self._selectedPreset?.color?.native
            }
        }
    }
    fileprivate var _items: [UI.View.Segmented.Item] = [] {
        willSet {
            self.removeAllSegments()
        }
        didSet {
            for item in self._items {
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
        self._delegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(items: [UI.View.Segmented.Item]) {
        self._items = items
    }
    
    func update(selected: UI.View.Segmented.Item?) {
        if let selected = selected {
            if let index = self._items.firstIndex(of: selected) {
                self._update(selected: index)
            } else {
                self._update(selected: Self.noSegment)
            }
        } else {
            self._update(selected: Self.noSegment)
        }
    }
    
    func update(preset: UI.View.Segmented.Preset?) {
        self._preset = preset
    }
    
    func update(selectedPreset: UI.View.Segmented.Preset?) {
        self._selectedPreset = selectedPreset
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
        self._delegate = nil
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
        self._delegate?.selected(self, index: self.selectedSegmentIndex)
    }
    
}

#endif
