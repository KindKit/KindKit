//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UI.View {

    final class Blur : IUIView, IUIViewReusable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
        public var color: UI.Color? = nil {
            didSet {
                guard self.color != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(color: self.color)
                }
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.cornerRadius != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(cornerRadius: self.cornerRadius)
                }
            }
        }
        public var border: UI.Border = .none {
            didSet {
                guard self.border != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(border: self.border)
                }
            }
        }
        public var shadow: UI.Shadow? = nil {
            didSet {
                guard self.shadow != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(shadow: self.shadow)
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
        public var style: UIBlurEffect.Style {
            didSet {
                guard self.style != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(style: self.style)
                }
            }
        }
        public var onAppear: ((UI.View.Blur) -> Void)?
        public var onDisappear: ((UI.View.Blur) -> Void)?
        public var onVisible: ((UI.View.Blur) -> Void)?
        public var onVisibility: ((UI.View.Blur) -> Void)?
        public var onInvisible: ((UI.View.Blur) -> Void)?
        
        private var _reuse: UI.Reuse.Item< Reusable >
        private var _view: KKBlurView {
            return self._reuse.content
        }
        
        public init(
            _ style: UIBlurEffect.Style
        ) {
            self.style = style
            self._reuse = UI.Reuse.Item()
            self._reuse.configure(owner: self)
        }
        
        public convenience init(
            style: UIBlurEffect.Style,
            configure: (UI.View.Blur) -> Void
        ) {
            self.init(style)
            self.modify(configure)
        }
        
        deinit {
            self._reuse.destroy()
        }
        
        public func loadIfNeeded() {
            self._reuse.loadIfNeeded()
        }
        
        public func size(available: SizeFloat) -> SizeFloat {
            return available
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
        
    }
    
}

public extension UI.View.Blur {
    
    @inlinable
    @discardableResult
    func style(_ value: UIBlurEffect.Style) -> Self {
        self.style = value
        return self
    }
    
}

public extension UI.View.Blur {
    
    @discardableResult
    func onAppear(_ value: ((UI.View.Blur) -> Void)?) -> Self {
        self.onAppear = value
        return self
    }
    
    @discardableResult
    func onDisappear(_ value: ((UI.View.Blur) -> Void)?) -> Self {
        self.onDisappear = value
        return self
    }
    
    @discardableResult
    func onVisible(_ value: ((UI.View.Blur) -> Void)?) -> Self {
        self.onVisible = value
        return self
    }
    
    @discardableResult
    func onVisibility(_ value: ((UI.View.Blur) -> Void)?) -> Self {
        self.onVisibility = value
        return self
    }
    
    @discardableResult
    func onInvisible(_ value: ((UI.View.Blur) -> Void)?) -> Self {
        self.onInvisible = value
        return self
    }
    
}

#endif
