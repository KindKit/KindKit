//
//  KindKitView
//

#if os(iOS)

import Foundation
import KindKitCore
import KindKitMath

protocol SegmentedViewDelegate : AnyObject {
    
    func selected(index: Int)
    
}

public final class SegmentedView : ISegmentedView {
    
    public private(set) unowned var layout: ILayout?
    public unowned var item: LayoutItem?
    public var native: NativeView {
        return self._view
    }
    public var isLoaded: Bool {
        return self._reuse.isLoaded
    }
    public var bounds: RectFloat {
        guard self.isLoaded == true else { return .zero }
        return RectFloat(self._view.bounds)
    }
    public private(set) var isVisible: Bool
    public var isHidden: Bool {
        didSet(oldValue) {
            guard self.isHidden != oldValue else { return }
            self.setNeedForceLayout()
        }
    }
    public var width: StaticSizeBehaviour {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var height: StaticSizeBehaviour {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var items: [SegmentedViewItem] {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(items: self.items)
        }
    }
    public var selectedItem: SegmentedViewItem? {
        set(value) {
            self._selectedItem = value
            guard self.isLoaded == true else { return }
            self._view.update(items: self.items, selectedItem: self._selectedItem)
        }
        get { return self._selectedItem }
    }
    public var isLocked: Bool {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(locked: self.isLocked)
        }
    }
    public var color: Color? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(color: self.color)
        }
    }
    public var border: ViewBorder {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(border: self.border)
        }
    }
    public var cornerRadius: ViewCornerRadius {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(cornerRadius: self.cornerRadius)
        }
    }
    public var shadow: ViewShadow? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(shadow: self.shadow)
        }
    }
    public var alpha: Float {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(alpha: self.alpha)
        }
    }
    
    private var _reuse: ReuseItem< Reusable >
    private var _view: Reusable.Content {
        return self._reuse.content()
    }
    private var _selectedItem: SegmentedViewItem?
    private var _onAppear: (() -> Void)?
    private var _onDisappear: (() -> Void)?
    private var _onVisible: (() -> Void)?
    private var _onVisibility: (() -> Void)?
    private var _onInvisible: (() -> Void)?
    private var _onChangeStyle: ((_ userInteraction: Bool) -> Void)?
    private var _onSelect: ((SegmentedViewItem) -> Void)?
    
    public init(
        width: StaticSizeBehaviour,
        height: StaticSizeBehaviour,
        items: [SegmentedViewItem],
        selectedItem: SegmentedViewItem?,
        isLocked: Bool = false,
        color: Color? = nil,
        border: ViewBorder = .none,
        cornerRadius: ViewCornerRadius = .none,
        shadow: ViewShadow? = nil,
        alpha: Float = 1,
        isHidden: Bool = false
    ) {
        self.isVisible = false
        self.width = width
        self.height = height
        self.items = items
        self._selectedItem = selectedItem
        self.isLocked = isLocked
        self.color = color
        self.border = border
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.alpha = alpha
        self.isHidden = isHidden
        self._reuse = ReuseItem()
        self._reuse.configure(owner: self)
    }
    
    deinit {
        self._reuse.destroy()
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        guard self.isHidden == false else { return .zero }
        return StaticSizeBehaviour.apply(
            available: available,
            width: self.width,
            height: self.height
        )
    }
    
    public func appear(to layout: ILayout) {
        self.layout = layout
        self._onAppear?()
    }
    
    public func disappear() {
        self._reuse.disappear()
        self.layout = nil
        self._onDisappear?()
    }
    
    public func visible() {
        self.isVisible = true
        self._onVisible?()
    }
    
    public func visibility() {
        self._onVisibility?()
    }
    
    public func invisible() {
        self.isVisible = false
        self._onInvisible?()
    }
    
    public func triggeredChangeStyle(_ userInteraction: Bool) {
        self._onChangeStyle?(userInteraction)
    }
    
    public func onAppear(_ value: (() -> Void)?) -> Self {
        self._onAppear = value
        return self
    }
    
    public func onDisappear(_ value: (() -> Void)?) -> Self {
        self._onDisappear = value
        return self
    }
    
    @discardableResult
    public func onVisible(_ value: (() -> Void)?) -> Self {
        self._onVisible = value
        return self
    }
    
    @discardableResult
    public func onVisibility(_ value: (() -> Void)?) -> Self {
        self._onVisibility = value
        return self
    }
    
    @discardableResult
    public func onInvisible(_ value: (() -> Void)?) -> Self {
        self._onInvisible = value
        return self
    }
    
    @discardableResult
    public func onChangeStyle(_ value: ((_ userInteraction: Bool) -> Void)?) -> Self {
        self._onChangeStyle = value
        return self
    }
    
    @discardableResult
    public func onSelect(_ value: ((SegmentedViewItem) -> Void)?) -> Self {
        self._onSelect = value
        return self
    }
    
}

extension SegmentedView : SegmentedViewDelegate {
    
    func selected(index: Int) {
        let selectedItem = self.items[index]
        self._selectedItem = selectedItem
        self._onSelect?(selectedItem)
    }
    
}

#endif
