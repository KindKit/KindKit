//
//  KindKit
//

import Foundation

protocol KKControlViewDelegate : AnyObject {
    
    func shouldHighlighting(_ view: KKControlView) -> Bool
    func set(_ view: KKControlView, highlighted: Bool)
    
    func shouldPressing(_ view: KKControlView) -> Bool
    func pressed(_ view: KKControlView)
    
}

public extension UI.View {
    
    final class Control : IUIView, IUIViewDynamicSizeable, IUIViewHighlightable, IUIViewLockable, IUIViewPressable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
        public var width: UI.Size.Dynamic = .fit {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Dynamic = .fit {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var content: IUILayout {
            willSet {
                self.content.view = nil
            }
            didSet(oldValue) {
                self.content.view = self
                guard self.isLoaded == true else { return }
                self._view.update(content: self.content)
                self.content.setNeedForceUpdate()
            }
        }
        public var contentSize: SizeFloat {
            get {
                guard self.isLoaded == true else { return .zero }
                return self._view.contentSize
            }
        }
        public var shouldHighlighting: Bool = false {
            didSet {
                if self.shouldHighlighting == false {
                    self.isHighlighted = false
                }
            }
        }
        public var isHighlighted: Bool {
            set(value) {
                if self._isHighlighted != value {
                    self._isHighlighted = value
                    self.triggeredChangeStyle(false)
                }
            }
            get { return self._isHighlighted }
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
        public var shouldPressed: Bool = false
        public var color: UI.Color? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(color: self.color)
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(cornerRadius: self.cornerRadius)
                self._view.updateShadowPath()
            }
        }
        public var border: UI.Border = .none {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(border: self.border)
            }
        }
        public var shadow: UI.Shadow? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(shadow: self.shadow)
                self._view.updateShadowPath()
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
        private var _isHighlighted: Bool = false
        private var _isLocked: Bool = false
        private var _onAppear: ((UI.View.Control) -> Void)?
        private var _onDisappear: ((UI.View.Control) -> Void)?
        private var _onVisible: ((UI.View.Control) -> Void)?
        private var _onVisibility: ((UI.View.Control) -> Void)?
        private var _onInvisible: ((UI.View.Control) -> Void)?
        private var _onChangeStyle: ((UI.View.Control, Bool) -> Void)?
        private var _onPressed: ((UI.View.Control) -> Void)?
        
        public init(
            _ content: IUILayout
        ) {
            self.content = content
            self._reuse = UI.Reuse.Item()
            self.content.view = self
            self._reuse.configure(owner: self)
        }
        
        public convenience init(
            content: IUILayout,
            configure: (UI.View.Control) -> Void
        ) {
            self.init(content)
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
            return UI.Size.Dynamic.apply(
                available: available,
                width: self.width,
                height: self.height,
                sizeWithWidth: { self.content.size(available: Size(width: $0, height: available.height)) },
                sizeWithHeight: { self.content.size(available: Size(width: available.width, height: $0)) },
                size: { self.content.size(available: available) }
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
        public func content(_ value: IUILayout) -> Self {
            self.content = value
            return self
        }
        
        @discardableResult
        public func onAppear(_ value: ((UI.View.Control) -> Void)?) -> Self {
            self._onAppear = value
            return self
        }
        
        @discardableResult
        public func onDisappear(_ value: ((UI.View.Control) -> Void)?) -> Self {
            self._onDisappear = value
            return self
        }
        
        @discardableResult
        public func onVisible(_ value: ((UI.View.Control) -> Void)?) -> Self {
            self._onVisible = value
            return self
        }
        
        @discardableResult
        public func onVisibility(_ value: ((UI.View.Control) -> Void)?) -> Self {
            self._onVisibility = value
            return self
        }
        
        @discardableResult
        public func onInvisible(_ value: ((UI.View.Control) -> Void)?) -> Self {
            self._onInvisible = value
            return self
        }
        
        @discardableResult
        public func onChangeStyle(_ value: ((UI.View.Control, Bool) -> Void)?) -> Self {
            self._onChangeStyle = value
            return self
        }
        
        @discardableResult
        public func onPressed(_ value: ((UI.View.Control) -> Void)?) -> Self {
            self._onPressed = value
            return self
        }
        
    }
    
}

public extension UI.View.Control {
    
    @inlinable
    @discardableResult
    func shouldHighlighting(_ value: Bool) -> Self {
        self.shouldHighlighting = value
        return self
    }
    
    @inlinable
    @discardableResult
    func shouldPressed(_ value: Bool) -> Self {
        self.shouldPressed = value
        return self
    }
    
}

extension UI.View.Control : KKControlViewDelegate {
    
    func shouldHighlighting(_ view: KKControlView) -> Bool {
        return self.shouldHighlighting
    }
    
    func set(_ view: KKControlView, highlighted: Bool) {
        if self._isHighlighted != highlighted {
            self._isHighlighted = highlighted
            self._onChangeStyle?(self, true)
        }
    }
    
    func shouldPressing(_ view: KKControlView) -> Bool {
        return self.shouldPressed
    }
    
    func pressed(_ view: KKControlView) {
        self._onPressed?(self)
    }
    
}
