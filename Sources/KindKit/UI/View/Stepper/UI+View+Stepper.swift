//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKStepperViewDelegate : AnyObject {
    
    func changed(_ view: KKStepperView, value: Double)
    
}

public extension UI.View {

    final class Stepper {
            
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
        public var size: UI.Size.Static = .init(.fixed(94), .fixed(29)) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedLayout()
            }
        }
        public var minValue: Double = 0 {
            didSet {
                guard self.minValue != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(minValue: self.minValue)
                }
            }
        }
        public var maxValue: Double = 100 {
            didSet {
                guard self.maxValue != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(maxValue: self.maxValue)
                }
            }
        }
        public var stepValue: Double = 1 {
            didSet {
                guard self.stepValue != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(stepValue: self.stepValue)
                }
            }
        }
        public var value: Double {
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
        public var isAutorepeat: Bool = true {
            didSet {
                guard self.isAutorepeat != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(isAutorepeat: self.isAutorepeat)
                }
            }
        }
        public var isWraps: Bool = false {
            didSet {
                guard self.isWraps != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(isWraps: self.isWraps)
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
        private var _value: Double = 0
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }
        
    }
    
}

public extension UI.View.Stepper {
    
    @inlinable
    @discardableResult
    func minValue(_ value: Double) -> Self {
        self.minValue = value
        return self
    }
    
    @inlinable
    @discardableResult
    func minValue(_ value: () -> Double) -> Self {
        return self.minValue(value())
    }

    @inlinable
    @discardableResult
    func minValue(_ value: (Self) -> Double) -> Self {
        return self.minValue(value(self))
    }
    
    @inlinable
    @discardableResult
    func maxValue(_ value: Double) -> Self {
        self.maxValue = value
        return self
    }
    
    @inlinable
    @discardableResult
    func maxValue(_ value: () -> Double) -> Self {
        return self.maxValue(value())
    }

    @inlinable
    @discardableResult
    func maxValue(_ value: (Self) -> Double) -> Self {
        return self.maxValue(value(self))
    }
    
    @inlinable
    @discardableResult
    func stepValue(_ value: Double) -> Self {
        self.stepValue = value
        return self
    }
    
    @inlinable
    @discardableResult
    func stepValue(_ value: () -> Double) -> Self {
        return self.stepValue(value())
    }

    @inlinable
    @discardableResult
    func stepValue(_ value: (Self) -> Double) -> Self {
        return self.stepValue(value(self))
    }
    
    @inlinable
    @discardableResult
    func value(_ value: Double) -> Self {
        self.value = value
        return self
    }
    
    @inlinable
    @discardableResult
    func value(_ value: () -> Double) -> Self {
        return self.value(value())
    }

    @inlinable
    @discardableResult
    func value(_ value: (Self) -> Double) -> Self {
        return self.value(value(self))
    }
    
    @inlinable
    @discardableResult
    func isAutorepeat(_ value: Bool) -> Self {
        self.isAutorepeat = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isAutorepeat(_ value: () -> Bool) -> Self {
        return self.isAutorepeat(value())
    }

    @inlinable
    @discardableResult
    func isAutorepeat(_ value: (Self) -> Bool) -> Self {
        return self.isAutorepeat(value(self))
    }
    
    @inlinable
    @discardableResult
    func isWraps(_ value: Bool) -> Self {
        self.isWraps = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isWraps(_ value: () -> Bool) -> Self {
        return self.isWraps(value())
    }

    @inlinable
    @discardableResult
    func isWraps(_ value: (Self) -> Bool) -> Self {
        return self.isWraps(value(self))
    }
    
}

extension UI.View.Stepper : IUIView {
    
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

extension UI.View.Stepper : IUIViewReusable {
    
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

extension UI.View.Stepper : IUIViewTransformable {
}

#endif

extension UI.View.Stepper : IUIViewStaticSizeable {
}

extension UI.View.Stepper : IUIViewColorable {
}

extension UI.View.Stepper : IUIViewAlphable {
}

extension UI.View.Stepper : IUIViewChangeable {
}

extension UI.View.Stepper : IUIViewLockable {
}

extension UI.View.Stepper : KKStepperViewDelegate {
    
    func changed(_ view: KKStepperView, value: Double) {
        if self._value != value {
            self._value = value
            self.onChange.emit()
        }
    }
    
}

public extension IUIView where Self == UI.View.Stepper {
    
    @inlinable
    static func stepper(_ value: Double) -> Self {
        return .init().value(value)
    }
    
}

#endif
