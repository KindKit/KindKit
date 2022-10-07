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
    
    final class Control : IUIView, IUIViewReusable, IUIViewDynamicSizeable, IUIViewHighlightable, IUIViewLockable, IUIViewPressable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
        public var width: UI.Size.Dynamic = .fit {
            didSet {
                guard self.width != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Dynamic = .fit {
            didSet {
                guard self.height != oldValue else { return }
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
            set {
                guard self._isHighlighted != newValue else { return }
                self._isHighlighted = newValue
                self.triggeredChangeStyle(false)
            }
            get { self._isHighlighted }
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
        public var shouldPressed: Bool = false
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
        public var content: IUILayout {
            willSet {
                guard self.content !== newValue else { return }
                self.content.view = nil
            }
            didSet {
                guard self.content !== oldValue else { return }
                self.content.view = self
                if self.isLoaded == true {
                    self._view.update(content: self.content)
                }
                self.content.setNeedForceUpdate()
            }
        }
        public var contentSize: SizeFloat {
            guard self.isLoaded == true else { return .zero }
            return self._view.contentSize
        }
        public let onAppear: Signal.Empty< Void > = .init()
        public let onDisappear: Signal.Empty< Void > = .init()
        public let onVisible: Signal.Empty< Void > = .init()
        public let onVisibility: Signal.Empty< Void > = .init()
        public let onInvisible: Signal.Empty< Void > = .init()
        public let onChangeStyle: Signal.Args< Void, Bool > = .init()
        public let onPressed: Signal.Empty< Void > = .init()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { return self._reuse.content }
        private var _isHighlighted: Bool = false
        private var _isLocked: Bool = false
        
        public init(
            _ content: IUILayout
        ) {
            self.content = content
            self.content.view = self
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

public extension UI.View.Control {
    
    @inlinable
    @discardableResult
    func content(_ value: IUILayout) -> Self {
        self.content = value
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
            self.onChangeStyle.emit(true)
        }
    }
    
    func shouldPressing(_ view: KKControlView) -> Bool {
        return self.shouldPressed
    }
    
    func pressed(_ view: KKControlView) {
        self.onPressed.emit()
    }
    
}
