//
//  KindKit
//

#if os(iOS)

import Foundation

protocol KKStepperViewDelegate : AnyObject {
    
    func changed(_ view: KKStepperView, value: Float)
    
}

public extension UI.View {

    final class Stepper : IUIView, IUIViewReusable, IUIViewStaticSizeable, IUIViewLockable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
            
        public var native: NativeView {
            return self._view
        }
        public var isLoaded: Bool {
            return self._reuse.isLoaded
        }
        public var bounds: RectFloat {
            guard self.isLoaded == true else { return .zero }
            return Rect(self._view.bounds)
        }
        public private(set) unowned var appearedLayout: IUILayout?
        public unowned var appearedItem: UI.Layout.Item?
        public private(set) var isVisible: Bool = false
        public var isHidden: Bool = false {
            didSet {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour {
            set { self._reuse.unloadBehaviour = newValue }
            get { return self._reuse.unloadBehaviour }
        }
        public var reuseCache: UI.Reuse.Cache? {
            set { self._reuse.cache = newValue }
            get { return self._reuse.cache }
        }
        public var reuseName: String? {
            set { self._reuse.name = newValue }
            get { return self._reuse.name }
        }
        public var width: UI.Size.Static = .fixed(94) {
            didSet {
                guard self.width != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Static = .fixed(29) {
            didSet {
                guard self.height != oldValue else { return }
                self.setNeedForceLayout()
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
            get { return self._isLocked }
        }
        public var color: UI.Color? = nil {
            didSet {
                guard self.color != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(color: self.color)
                }
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.cornerRadius != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(cornerRadius: self.cornerRadius)
                }
            }
        }
        public var border: UI.Border = .none {
            didSet {
                guard self.border != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(border: self.border)
                }
            }
        }
        public var shadow: UI.Shadow? = nil {
            didSet {
                guard self.shadow != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(shadow: self.shadow)
                }
            }
        }
        public var alpha: Float = 1 {
            didSet {
                guard self.alpha != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(alpha: self.alpha)
                }
            }
        }
        public var minValue: Float = 0 {
            didSet {
                guard self.minValue != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(minValue: self.minValue)
                }
            }
        }
        public var maxValue: Float = 100 {
            didSet {
                guard self.maxValue != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(maxValue: self.maxValue)
                }
            }
        }
        public var stepValue: Float = 1 {
            didSet {
                guard self.stepValue != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(stepValue: self.stepValue)
                }
            }
        }
        public var value: Float {
            set {
                guard self._value != newValue else { return }
                self._value = newValue
                if self.isLoaded == true {
                    self._view.update(value: self._value)
                }
            }
            get { return self._value }
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
        public var onAppear: ((UI.View.Stepper) -> Void)?
        public var onDisappear: ((UI.View.Stepper) -> Void)?
        public var onVisible: ((UI.View.Stepper) -> Void)?
        public var onVisibility: ((UI.View.Stepper) -> Void)?
        public var onInvisible: ((UI.View.Stepper) -> Void)?
        public var onChangeStyle: ((UI.View.Stepper, Bool) -> Void)?
        public var onChangeValue: ((UI.View.Stepper) -> Void)?
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { return self._reuse.content }
        private var _isLocked: Bool = false
        private var _value: Float = 0
        
        public init() {
        }
        
        public convenience init(
            configure: (UI.View.Stepper) -> Void
        ) {
            self.init()
            self.modify(configure)
        }
        
        deinit {
            self._reuse.destroy()
        }
        
        public func loadIfNeeded() {
            self._reuse.loadIfNeeded()
        }
        
        public func size(available: SizeFloat) -> SizeFloat {
            guard self.isHidden == false else { return .zero }
            return UI.Size.Static.apply(
                available: available,
                width: self.width,
                height: self.height
            )
        }
        
        public func appear(to layout: IUILayout) {
            self.appearedLayout = layout
            self.onAppear?(self)
        }
        
        public func disappear() {
            self._reuse.disappear()
            self.appearedLayout = nil
            self.onDisappear?(self)
        }
        
        public func visible() {
            self.isVisible = true
            self.onVisible?(self)
        }
        
        public func visibility() {
            self.onVisibility?(self)
        }
        
        public func invisible() {
            self.isVisible = false
            self.onInvisible?(self)
        }
        
        public func triggeredChangeStyle(_ userInteraction: Bool) {
            self.onChangeStyle?(self, userInteraction)
        }
        
    }
    
}

public extension UI.View.Stepper {
    
    @inlinable
    @discardableResult
    func minValue(_ value: Float) -> Self {
        self.minValue = value
        return self
    }
    
    @inlinable
    @discardableResult
    func maxValue(_ value: Float) -> Self {
        self.maxValue = value
        return self
    }
    
    @inlinable
    @discardableResult
    func stepValue(_ value: Float) -> Self {
        self.stepValue = value
        return self
    }
    
    @inlinable
    @discardableResult
    func value(_ value: Float) -> Self {
        self.value = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isAutorepeat(_ value: Bool) -> Self {
        self.isAutorepeat = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isWraps(_ value: Bool) -> Self {
        self.isWraps = value
        return self
    }
    
}

public extension UI.View.Stepper {
    
    @inlinable
    @discardableResult
    func onAppear(_ value: ((UI.View.Stepper) -> Void)?) -> Self {
        self.onAppear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ value: ((UI.View.Stepper) -> Void)?) -> Self {
        self.onDisappear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ value: ((UI.View.Stepper) -> Void)?) -> Self {
        self.onVisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ value: ((UI.View.Stepper) -> Void)?) -> Self {
        self.onVisibility = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ value: ((UI.View.Stepper) -> Void)?) -> Self {
        self.onInvisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeStyle(_ value: ((UI.View.Stepper, Bool) -> Void)?) -> Self {
        self.onChangeStyle = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeValue(_ value: ((UI.View.Stepper) -> Void)?) -> Self {
        self.onChangeValue = value
        return self
    }
    
}

extension UI.View.Stepper : KKStepperViewDelegate {
    
    func changed(_ view: KKStepperView, value: Float) {
        self._value = value
        self.onChangeValue?(self)
    }
    
}

#endif
