//
//  KindKit
//

import Foundation

protocol KKSwitchViewDelegate : AnyObject {
    
    func changed(_ view: KKSwitchView, value: Bool)
    
}

public extension UI.View {

    final class Switch {
        
        public private(set) weak var appearedLayout: IUILayout?
        public var frame: KindKit.Rect = .zero {
            didSet {
                guard self.frame != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(frame: self.frame)
                }
            }
        }
#if os(iOS)
        public var transform: UI.Transform = .init() {
            didSet {
                guard self.transform != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(transform: self.transform)
                }
            }
        }
#endif
        public var size: UI.Size.Static = .init(.fixed(51), .fixed(31)) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedLayout()
            }
        }
        public var thumbColor: UI.Color? {
            didSet {
                guard self.thumbColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(thumbColor: self.thumbColor)
                }
            }
        }
        public var offColor: UI.Color? {
            didSet {
                guard self.offColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(offColor: self.offColor)
                }
            }
        }
        public var onColor: UI.Color? {
            didSet {
                guard self.onColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(onColor: self.onColor)
                }
            }
        }
        public var value: Bool {
            set {
                guard self._value != newValue else { return }
                self._value = newValue
                if self.isLoaded == true {
                    self._view.update(value: self._value)
                }
            }
            get { self._value }
        }
        public var color: UI.Color? {
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
        public var isLocked: Bool {
            set {
                guard self._isLocked != newValue else { return }
                self._isLocked = newValue
                if self.isLoaded == true {
                    self._view.update(locked: self._isLocked)
                }
                self.triggeredChangeStyle(false)
            }
            get { self._isLocked }
        }
        public var isHidden: Bool = false {
            didSet {
                guard self.isHidden != oldValue else { return }
                self.setNeedLayout()
            }
        }
        public private(set) var isVisible: Bool = false
        public let onAppear = Signal.Empty< Void >()
        public let onDisappear = Signal.Empty< Void >()
        public let onVisible = Signal.Empty< Void >()
        public let onInvisible = Signal.Empty< Void >()
        public let onStyle = Signal.Args< Void, Bool >()
        public let onChange = Signal.Empty< Void >()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        private var _isLocked: Bool = false
        private var _value: Bool = false
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }
        
    }
    
}

public extension UI.View.Switch {
    
    @inlinable
    @discardableResult
    func thumbColor(_ value: UI.Color) -> Self {
        self.thumbColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func thumbColor(_ value: () -> UI.Color) -> Self {
        return self.thumbColor(value())
    }

    @inlinable
    @discardableResult
    func thumbColor(_ value: (Self) -> UI.Color) -> Self {
        return self.thumbColor(value(self))
    }
    
    @inlinable
    @discardableResult
    func offColor(_ value: UI.Color) -> Self {
        self.offColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func offColor(_ value: () -> UI.Color) -> Self {
        return self.offColor(value())
    }

    @inlinable
    @discardableResult
    func offColor(_ value: (Self) -> UI.Color) -> Self {
        return self.offColor(value(self))
    }
    
    @inlinable
    @discardableResult
    func onColor(_ value: UI.Color) -> Self {
        self.onColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onColor(_ value: () -> UI.Color) -> Self {
        return self.onColor(value())
    }

    @inlinable
    @discardableResult
    func onColor(_ value: (Self) -> UI.Color) -> Self {
        return self.onColor(value(self))
    }
    
    @inlinable
    @discardableResult
    func value(_ value: Bool) -> Self {
        self.value = value
        return self
    }
    
    @inlinable
    @discardableResult
    func value(_ value: () -> Bool) -> Self {
        return self.value(value())
    }

    @inlinable
    @discardableResult
    func value(_ value: (Self) -> Bool) -> Self {
        return self.value(value(self))
    }
    
}

extension UI.View.Switch : IUIView {
    
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
    
    public func appear(to layout: IUILayout) {
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

extension UI.View.Switch : IUIViewReusable {
    
    public var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour {
        set { self._reuse.unloadBehaviour = newValue }
        get { self._reuse.unloadBehaviour }
    }
    
    public var reuseCache: UI.Reuse.Cache? {
        set { self._reuse.cache = newValue }
        get { self._reuse.cache }
    }
    
    public var reuseName: String? {
        set { self._reuse.name = newValue }
        get { self._reuse.name }
    }
    
}

#if os(iOS)

extension UI.View.Switch : IUIViewTransformable {
}

#endif

extension UI.View.Switch : IUIViewStaticSizeable {
}

extension UI.View.Switch : IUIViewChangeable {
}

extension UI.View.Switch : IUIViewLockable {
}

extension UI.View.Switch : IUIViewColorable {
}

extension UI.View.Switch : IUIViewAlphable {
}

extension UI.View.Switch : KKSwitchViewDelegate {
    
    func changed(_ view: KKSwitchView, value: Bool) {
        if self._value != value {
            self._value = value
            self.onChange.emit()
        }
    }
    
}

public extension IUIView where Self == UI.View.Switch {
    
    @inlinable
    static func `switch`(_ value: Bool) -> Self {
        return .init().value(value)
    }
    
}
