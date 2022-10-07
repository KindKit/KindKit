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
        public var style: UIBlurEffect.Style {
            didSet {
                guard self.style != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(style: self.style)
                }
            }
        }
        public let onAppear: Signal.Empty< Void > = .init()
        public let onDisappear: Signal.Empty< Void > = .init()
        public let onVisible: Signal.Empty< Void > = .init()
        public let onVisibility: Signal.Empty< Void > = .init()
        public let onInvisible: Signal.Empty< Void > = .init()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        private var _view: KKBlurView {
            return self._reuse.content
        }
        
        public init(
            _ style: UIBlurEffect.Style
        ) {
            self.style = style
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
    
}

public extension UI.View.Blur {
    
    @inlinable
    @discardableResult
    func style(_ value: UIBlurEffect.Style) -> Self {
        self.style = value
        return self
    }
    
}

#endif
