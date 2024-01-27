//
//  KindKit
//

import KindEvent
import KindGraphics
import KindMath

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKSegmentedViewDelegate : AnyObject {
    
    func selected(_ view: KKSegmentedView, index: Int)
    
}

public final class SegmentedView {
    
    public private(set) weak var appearedLayout: Layout?
    public var frame: Rect = .zero {
        didSet {
            guard self.frame != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(frame: self.frame)
            }
        }
    }
#if os(iOS)
    public var transform: Transform = .init() {
        didSet {
            guard self.transform != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(transform: self.transform)
            }
        }
    }
#endif
    public var size: StaticSize = .init(.fill, .fixed(32)) {
        didSet {
            guard self.size != oldValue else { return }
            self.setNeedLayout()
        }
    }
    public var items: [Item] = [] {
        didSet {
            guard self.items != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(items: self.items)
            }
            if let selected = self.selected {
                if self.items.contains(selected) == false {
                    self.selected = self.items.first
                }
            } else {
                self.selected = self.items.first
            }
        }
    }
    public var selected: Item? {
        set {
            guard self._selected != newValue else { return }
            self._selected = newValue
            if self.isLoaded == true {
                self._view.update(selected: self._selected)
            }
        }
        get { self._selected }
    }
    public var preset: Preset? {
        didSet {
            guard self.preset != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(preset: self.preset)
            }
        }
    }
    public var selectedPreset: Preset? {
        didSet {
            guard self.selectedPreset != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(selectedPreset: self.selectedPreset)
            }
        }
    }
    public var color: Color? {
        didSet {
            guard self.color != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(color: self.color)
            }
        }
    }
    public var alpha: Double = 1 {
        didSet {
            guard self.alpha != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(alpha: self.alpha)
            }
        }
    }
    public var isLocked: Bool = false {
        didSet {
            guard self.isLocked != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(locked: self.isLocked)
            }
        }
    }
    public var isHidden: Bool = false {
        didSet {
            guard self.isHidden != oldValue else { return }
            self.setNeedLayout()
        }
    }
    public private(set) var isVisible: Bool = false
    public let onAppear = Signal< Void, Void >()
    public let onDisappear = Signal< Void, Void >()
    public let onVisible = Signal< Void, Void >()
    public let onInvisible = Signal< Void, Void >()
    public let onStyle = Signal< Void, Bool >()
    public let onSelect: Signal< Void, SegmentedView.Item > = .init()
    
    private lazy var _reuse: Reuse.Item< Reusable > = .init(owner: self)
    @inline(__always) private var _view: Reusable.Content { self._reuse.content }
    private var _selected: Item?
    
    public init() {
    }
    
    deinit {
        self._reuse.destroy()
    }
    
}

public extension SegmentedView {
    
    @inlinable
    var selectedIndex: Int? {
        guard let selected = self.selected else { return nil }
        return self.items.firstIndex(of: selected)
    }
    
}

public extension SegmentedView {
    
    @inlinable
    @discardableResult
    func items(_ value: [Item]) -> Self {
        self.items = value
        return self
    }
    
    @inlinable
    @discardableResult
    func items(_ value: () -> [Item]) -> Self {
        return self.items(value())
    }

    @inlinable
    @discardableResult
    func items(_ value: (Self) -> [Item]) -> Self {
        return self.items(value(self))
    }
    
    @inlinable
    @discardableResult
    func selected(_ value: Item?) -> Self {
        self.selected = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selected(_ value: () -> Item?) -> Self {
        return self.selected(value())
    }

    @inlinable
    @discardableResult
    func selected(_ value: (Self) -> Item?) -> Self {
        return self.selected(value(self))
    }
    
    @inlinable
    @discardableResult
    func preset(_ value: Preset?) -> Self {
        self.preset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func preset(_ value: () -> Preset?) -> Self {
        return self.preset(value())
    }

    @inlinable
    @discardableResult
    func preset(_ value: (Self) -> Preset?) -> Self {
        return self.preset(value(self))
    }
    
    @inlinable
    @discardableResult
    func selectedPreset(_ value: Preset?) -> Self {
        self.selectedPreset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selectedPreset(_ value: () -> Preset?) -> Self {
        return self.selectedPreset(value())
    }

    @inlinable
    @discardableResult
    func selectedPreset(_ value: (Self) -> Preset?) -> Self {
        return self.selectedPreset(value(self))
    }
    
}

public extension SegmentedView {
    
    @inlinable
    @discardableResult
    func onSelect(_ closure: @escaping () -> Void) -> Self {
        self.onSelect.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelect(_ closure: @escaping (Self) -> Void) -> Self {
        self.onSelect.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelect(_ closure: @escaping (SegmentedView.Item) -> Void) -> Self {
        self.onSelect.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelect(_ closure: @escaping (Self, SegmentedView.Item) -> Void) -> Self {
        self.onSelect.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelect< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onSelect.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelect< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, SegmentedView.Item) -> Void) -> Self {
        self.onSelect.add(sender, closure)
        return self
    }
    
}

extension SegmentedView : IView {
    
    public var native: NativeView {
        self._view
    }
    
    public var isLoaded: Bool {
        self._reuse.isLoaded
    }
    
    public var bounds: Rect {
        guard self.isLoaded == true else { return .zero }
        return .init(self._view.bounds)
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: Size) -> Size {
        guard self.isHidden == false else { return .zero }
        return self.size.apply(available: available)
    }
    
    public func appear(to layout: Layout) {
        self.appearedLayout = layout
        self.onAppear.emit()
    }
    
    public func disappear() {
        self._reuse.disappear()
        self.appearedLayout = nil
        self.onDisappear.emit()
    }
    
    public func visible() {
        self.isVisible = true
        self.onVisible.emit()
    }
    
    public func invisible() {
        self.isVisible = false
        self.onInvisible.emit()
    }
    
}

extension SegmentedView : IViewReusable {
    
    public var reuseUnloadBehaviour: Reuse.UnloadBehaviour {
        set { self._reuse.unloadBehaviour = newValue }
        get { self._reuse.unloadBehaviour }
    }
    
    public var reuseCache: ReuseCache? {
        set { self._reuse.cache = newValue }
        get { self._reuse.cache }
    }
    
    public var reuseName: String? {
        set { self._reuse.name = newValue }
        get { self._reuse.name }
    }
    
}

#if os(iOS)

extension SegmentedView : IViewSupportTransform {
}

#endif

extension SegmentedView : IViewSupportStaticSize {
}

extension SegmentedView : IViewLockable {
}

extension SegmentedView : IViewSupportColor {
}

extension SegmentedView : IViewSupportAlpha {
}

extension SegmentedView : KKSegmentedViewDelegate {
    
    func selected(_ view: KKSegmentedView, index: Int) {
        let selected = self.items[index]
        if self._selected != selected {
            self._selected = selected
            self.onSelect.emit(selected)
        }
    }
    
}

#endif
