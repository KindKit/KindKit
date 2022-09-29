//
//  KindKit
//

import Foundation

protocol KKCustomViewDelegate : AnyObject {
    
    func shouldHighlighting(_ view: KKCustomView) -> Bool
    func set(_ view: KKCustomView, highlighted: Bool)
    
}

public extension UI.View {

    final class Custom : IUIView, IUIViewReusable, IUIViewDynamicSizeable, IUIViewHighlightable, IUIViewLockable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
            didSet(oldValue) {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour {
            set(value) { self._reuse.unloadBehaviour = value }
            get { return self._reuse.unloadBehaviour }
        }
        public var reuseCache: UI.Reuse.Cache? {
            set(value) { self._reuse.cache = value }
            get { return self._reuse.cache }
        }
        public var reuseName: String? {
            set(value) { self._reuse.name = value }
            get { return self._reuse.name }
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
                self._view.updateShadowPath()
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
        public var gestures: [IUIGesture] {
            set(value) {
                self._gestures = value
                if self.isLoaded == true {
                    self._view.update(gestures: value)
                }
            }
            get { return self._gestures }
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
                self.setNeedForceLayout()
            }
        }
        public var contentSize: SizeFloat {
            guard self.isLoaded == true else { return .zero }
            return self._view.contentSize
        }
        public var onAppear: ((UI.View.Custom) -> Void)?
        public var onDisappear: ((UI.View.Custom) -> Void)?
        public var onVisible: ((UI.View.Custom) -> Void)?
        public var onVisibility: ((UI.View.Custom) -> Void)?
        public var onInvisible: ((UI.View.Custom) -> Void)?
        public var onChangeStyle: ((UI.View.Custom, Bool) -> Void)?
        
        private var _reuse: UI.Reuse.Item< Reusable >
        private var _view: Reusable.Content {
            return self._reuse.content
        }
        private var _gestures: [IUIGesture] = []
        private var _isHighlighted: Bool = false
        private var _isLocked: Bool = false
        
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
            configure: (UI.View.Custom) -> Void
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

public extension UI.View.Custom {
    
    @inlinable
    @discardableResult
    func gestures(_ value: [IUIGesture]) -> Self {
        self.gestures = value
        return self
    }
    
    @discardableResult
    func add(gesture: IUIGesture) -> Self {
        if self._gestures.contains(where: { $0 === gesture }) == false {
            self._gestures.append(gesture)
            if self.isLoaded == true {
                self._view.add(gesture: gesture)
            }
        }
        return self
    }
    
    @discardableResult
    func remove(gesture: IUIGesture) -> Self {
        if let index = self._gestures.firstIndex(where: { $0 === gesture }) {
            self._gestures.remove(at: index)
            if self.isLoaded == true {
                self._view.remove(gesture: gesture)
            }
        }
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: IUILayout) -> Self {
        self.content = value
        return self
    }
    
}

public extension UI.View.Custom {
    
    @inlinable
    @discardableResult
    func onAppear(_ value: ((UI.View.Custom) -> Void)?) -> Self {
        self.onAppear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ value: ((UI.View.Custom) -> Void)?) -> Self {
        self.onDisappear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ value: ((UI.View.Custom) -> Void)?) -> Self {
        self.onVisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ value: ((UI.View.Custom) -> Void)?) -> Self {
        self.onVisibility = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ value: ((UI.View.Custom) -> Void)?) -> Self {
        self.onInvisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeStyle(_ value: ((UI.View.Custom, Bool) -> Void)?) -> Self {
        self.onChangeStyle = value
        return self
    }
    
}


extension UI.View.Custom : KKCustomViewDelegate {
    
    func shouldHighlighting(_ view: KKCustomView) -> Bool {
        return self.shouldHighlighting
    }
    
    func set(_ view: KKCustomView, highlighted: Bool) {
        if self._isHighlighted != highlighted {
            self._isHighlighted = highlighted
            self.onChangeStyle?(self, true)
        }
    }
    
}
