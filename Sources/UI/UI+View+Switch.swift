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
        public weak var appearedItem: UI.Layout.Item?
        public var size: UI.Size.Static = .init(width: .fixed(51), height: .fixed(31)) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedForceLayout()
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
        public var alpha: Float = 1 {
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
                self.setNeedForceLayout()
            }
        }
        public private(set) var isVisible: Bool = false
        public let onAppear: Signal.Empty< Void > = .init()
        public let onDisappear: Signal.Empty< Void > = .init()
        public let onVisible: Signal.Empty< Void > = .init()
        public let onVisibility: Signal.Empty< Void > = .init()
        public let onInvisible: Signal.Empty< Void > = .init()
        public let onStyle: Signal.Args< Void, Bool > = .init()
        public let onChange: Signal.Empty< Void > = .init()
        
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
    func offColor(_ value: UI.Color) -> Self {
        self.offColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onColor(_ value: UI.Color) -> Self {
        self.onColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func value(_ value: Bool) -> Self {
        self.value = value
        return self
    }
    
}

extension UI.View.Switch : IUIView {
    
    public var native: NativeView {
        self._view
    }
    
    public var isLoaded: Bool {
        self._reuse.isLoaded
    }
    
    public var bounds: RectFloat {
        guard self.isLoaded == true else { return .zero }
        return .init(self._view.bounds)
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
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
    
    public func visibility() {
        self.onVisibility.emit()
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
