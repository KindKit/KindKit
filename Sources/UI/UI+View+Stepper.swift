//
//  KindKit
//

#if os(iOS)

import Foundation

protocol KKStepperViewDelegate : AnyObject {
    
    func changed(_ view: KKStepperView, value: Float)
    
}

public extension UI.View {

    final class Stepper : IUIView, IUIViewStaticSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
            
        public private(set) unowned var layout: IUILayout?
        public unowned var item: UI.Layout.Item?
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
        public private(set) var isVisible: Bool = false
        public var isHidden: Bool = false {
            didSet(oldValue) {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var width: UI.Size.Static = .fixed(94) {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Static = .fixed(29) {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var minValue: Float = 0 {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(minValue: self.minValue)
            }
        }
        public var maxValue: Float = 100 {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(maxValue: self.maxValue)
            }
        }
        public var stepValue: Float = 1 {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(stepValue: self.stepValue)
            }
        }
        public var value: Float {
            set(value) {
                self._value = value
                guard self.isLoaded == true else { return }
                self._view.update(value: self._value)
            }
            get { return self._value }
        }
        public var isAutorepeat: Bool = true {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(isAutorepeat: self.isAutorepeat)
            }
        }
        public var isWraps: Bool = false {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(isWraps: self.isWraps)
            }
        }
        public var isLocked: Bool {
            set(value) {
                if self._isLocked != value {
                    self._isLocked = value
                    if self.isLoaded == true {
                        self._view.update(locked: self._isLocked)
                    }
                    self.triggeredChangeStyle(false)
                }
            }
            get { return self._isLocked }
        }
        public var color: Color? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(color: self.color)
            }
        }
        public var border: UI.Border = .none {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(border: self.border)
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(cornerRadius: self.cornerRadius)
            }
        }
        public var shadow: UI.Shadow? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(shadow: self.shadow)
            }
        }
        public var alpha: Float = 1 {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(alpha: self.alpha)
            }
        }
        
        private var _reuse: UI.Reuse.Item< Reusable >
        private var _view: Reusable.Content {
            return self._reuse.content()
        }
        private var _isLocked: Bool = false
        private var _value: Float = 0
        private var _onAppear: ((UI.View.Stepper) -> Void)?
        private var _onDisappear: ((UI.View.Stepper) -> Void)?
        private var _onVisible: ((UI.View.Stepper) -> Void)?
        private var _onVisibility: ((UI.View.Stepper) -> Void)?
        private var _onInvisible: ((UI.View.Stepper) -> Void)?
        private var _onChangeStyle: ((UI.View.Stepper, Bool) -> Void)?
        private var _onChangeValue: ((UI.View.Stepper) -> Void)?
        
        public init() {
            self._reuse = UI.Reuse.Item()
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
            return UI.Size.Static.apply(
                available: available,
                width: self.width,
                height: self.height
            )
        }
        
        public func appear(to layout: IUILayout) {
            self.layout = layout
            self._onAppear?(self)
        }
        
        public func disappear() {
            self._reuse.disappear()
            self.layout = nil
            self._onDisappear?(self)
        }
        
        public func visible() {
            self.isVisible = true
            self._onVisible?(self)
        }
        
        public func visibility() {
            self._onVisibility?(self)
        }
        
        public func invisible() {
            self.isVisible = false
            self._onInvisible?(self)
        }
        
        public func triggeredChangeStyle(_ userInteraction: Bool) {
            self._onChangeStyle?(self, userInteraction)
        }
        
        @discardableResult
        public func onAppear(_ value: ((UI.View.Stepper) -> Void)?) -> Self {
            self._onAppear = value
            return self
        }
        
        @discardableResult
        public func onDisappear(_ value: ((UI.View.Stepper) -> Void)?) -> Self {
            self._onDisappear = value
            return self
        }
        
        @discardableResult
        public func onVisible(_ value: ((UI.View.Stepper) -> Void)?) -> Self {
            self._onVisible = value
            return self
        }
        
        @discardableResult
        public func onVisibility(_ value: ((UI.View.Stepper) -> Void)?) -> Self {
            self._onVisibility = value
            return self
        }
        
        @discardableResult
        public func onInvisible(_ value: ((UI.View.Stepper) -> Void)?) -> Self {
            self._onInvisible = value
            return self
        }
        
        @discardableResult
        public func onChangeStyle(_ value: ((UI.View.Stepper, Bool) -> Void)?) -> Self {
            self._onChangeStyle = value
            return self
        }
        
        @discardableResult
        public func onChangeValue(_ value: ((UI.View.Stepper) -> Void)?) -> Self {
            self._onChangeValue = value
            return self
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

extension UI.View.Stepper : KKStepperViewDelegate {
    
    func changed(_ view: KKStepperView, value: Float) {
        self._value = value
        self._onChangeValue?(self)
    }
    
}

#endif
