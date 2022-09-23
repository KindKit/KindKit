//
//  KindKit
//

#if os(iOS)

import Foundation

public extension UI.View {

    final class Gradient : IUIView, IUIViewStaticSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
        public var width: UI.Size.Static = .fill {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Static = .fill {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var aspectRatio: Float? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var fill: Fill {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(fill: self.fill)
            }
        }
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
        private var _onAppear: ((UI.View.Gradient) -> Void)?
        private var _onDisappear: ((UI.View.Gradient) -> Void)?
        private var _onVisible: ((UI.View.Gradient) -> Void)?
        private var _onVisibility: ((UI.View.Gradient) -> Void)?
        private var _onInvisible: ((UI.View.Gradient) -> Void)?
        
        public init(
            _ fill: Fill
        ) {
            self.fill = fill
            self._reuse = UI.Reuse.Item()
            self._reuse.configure(owner: self)
        }
        
        public convenience init(
            fill: Fill,
            configure: (UI.View.Gradient) -> Void
        ) {
            self.init(fill)
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
                height: self.height,
                aspectRatio: self.aspectRatio
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
        
        @discardableResult
        public func onAppear(_ value: ((UI.View.Gradient) -> Void)?) -> Self {
            self._onAppear = value
            return self
        }
        
        @discardableResult
        public func onDisappear(_ value: ((UI.View.Gradient) -> Void)?) -> Self {
            self._onDisappear = value
            return self
        }
        
        @discardableResult
        public func onVisible(_ value: ((UI.View.Gradient) -> Void)?) -> Self {
            self._onVisible = value
            return self
        }
        
        @discardableResult
        public func onVisibility(_ value: ((UI.View.Gradient) -> Void)?) -> Self {
            self._onVisibility = value
            return self
        }
        
        @discardableResult
        public func onInvisible(_ value: ((UI.View.Gradient) -> Void)?) -> Self {
            self._onInvisible = value
            return self
        }
        
    }
    
}

public extension UI.View.Gradient {
    
    @inlinable
    @discardableResult
    func aspectRatio(_ value: Float?) -> Self {
        self.aspectRatio = value
        return self
    }
    
    @inlinable
    @discardableResult
    func fill(_ value: Fill) -> Self {
        self.fill = value
        return self
    }
    
}

#endif
