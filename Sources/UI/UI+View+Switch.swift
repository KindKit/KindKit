//
//  KindKit
//

#if os(iOS)

import Foundation

protocol KKSwitchViewDelegate : AnyObject {
    
    func changed(_ view: KKSwitchView, value: Bool)
    
}

public extension UI.View {

    final class Switch : IUIView, IUIViewStaticSizeable, IUIViewLockable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
            
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
        public var width: UI.Size.Static = .fixed(51) {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Static = .fixed(31) {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var thumbColor: UI.Color? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(thumbColor: self.thumbColor)
            }
        }
        public var offColor: UI.Color? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(offColor: self.offColor)
            }
        }
        public var onColor: UI.Color? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(onColor: self.onColor)
            }
        }
        public var value: Bool {
            set(value) {
                self._value = value
                guard self.isLoaded == true else { return }
                self._view.update(value: self._value)
            }
            get { return self._value }
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
        public var color: UI.Color? = nil {
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
        private var _value: Bool = false
        private var _onAppear: ((UI.View.Switch) -> Void)?
        private var _onDisappear: ((UI.View.Switch) -> Void)?
        private var _onVisible: ((UI.View.Switch) -> Void)?
        private var _onVisibility: ((UI.View.Switch) -> Void)?
        private var _onInvisible: ((UI.View.Switch) -> Void)?
        private var _onChangeStyle: ((UI.View.Switch, Bool) -> Void)?
        private var _onChangeValue: ((UI.View.Switch) -> Void)?
        
        public init() {
            self._reuse = UI.Reuse.Item()
            self._reuse.configure(owner: self)
        }
        
        public convenience init(
            configure: (UI.View.Switch) -> Void
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
        public func onAppear(_ value: ((UI.View.Switch) -> Void)?) -> Self {
            self._onAppear = value
            return self
        }
        
        @discardableResult
        public func onDisappear(_ value: ((UI.View.Switch) -> Void)?) -> Self {
            self._onDisappear = value
            return self
        }
        
        @discardableResult
        public func onVisible(_ value: ((UI.View.Switch) -> Void)?) -> Self {
            self._onVisible = value
            return self
        }
        
        @discardableResult
        public func onVisibility(_ value: ((UI.View.Switch) -> Void)?) -> Self {
            self._onVisibility = value
            return self
        }
        
        @discardableResult
        public func onInvisible(_ value: ((UI.View.Switch) -> Void)?) -> Self {
            self._onInvisible = value
            return self
        }
        
        @discardableResult
        public func onChangeStyle(_ value: ((UI.View.Switch, Bool) -> Void)?) -> Self {
            self._onChangeStyle = value
            return self
        }
        
        @discardableResult
        public func onChangeValue(_ value: ((UI.View.Switch) -> Void)?) -> Self {
            self._onChangeValue = value
            return self
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

extension UI.View.Switch : KKSwitchViewDelegate {
    
    func changed(_ view: KKSwitchView, value: Bool) {
        self._value = value
        self._onChangeValue?(self)
    }
    
}

#endif
