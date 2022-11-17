//
//  KindKit
//

import Foundation

public extension UI.View {

    final class Mask {
        
        public private(set) weak var appearedLayout: IUILayout?
        public weak var appearedItem: UI.Layout.Item?
        public var size: UI.Size.Dynamic = .init(width: .fit, height: .fit) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var content: IUIView? {
            didSet {
                guard self.content !== oldValue else { return }
                self.layout.content = self.content.flatMap({ UI.Layout.Item($0) })
            }
        }
        public var color: UI.Color? {
            didSet {
                guard self.color != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(color: self.color)
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
        public var cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.cornerRadius != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(cornerRadius: self.cornerRadius)
                    self._view.updateShadowPath()
                }
            }
        }
        public var shadow: UI.Shadow? {
            didSet {
                guard self.shadow != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(shadow: self.shadow)
                    self._view.updateShadowPath()
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
        public var isHidden: Bool = false {
            didSet {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public private(set) var isVisible: Bool = false
        public let onAppear: Signal.Empty< Void > = .init()
        public let onDisappear: Signal.Empty< Void > = .init()
        public let onVisible: Signal.Empty< Void > = .init()
        public let onVisibility: Signal.Empty< Void > = .init()
        public let onInvisible: Signal.Empty< Void > = .init()
        
        lazy var layout = UI.View.Mask.Layout()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        
        public init() {
            self.layout.view = self
        }
        
        deinit {
            self._reuse.destroy()
        }

    }
    
}

public extension UI.View.Mask {
    
    @inlinable
    @discardableResult
    func content(_ value: IUIView?) -> Self {
        self.content = value
        return self
    }
    
}

extension UI.View.Mask : IUIView {
    
    public var native: NativeView {
        self._view
    }
    
    public var isLoaded: Bool {
        self._reuse.isLoaded
    }
    
    public var bounds: RectFloat {
        guard self.isLoaded == true else { return .zero }
        return .init(self._view.bounds)
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        guard self.isHidden == false else { return .zero }
        return self.size.apply(
            available: available,
            sizeWithWidth: {
                guard let content = self.content else { return .init(width: $0, height: 0) }
                return content.size(available: .init(width: $0, height: available.height))
            },
            sizeWithHeight: {
                guard let content = self.content else { return .init(width: 0, height: $0) }
                return content.size(available: .init(width: available.width, height: $0))
            },
            size: {
                guard let content = self.content else { return .zero }
                return content.size(available: available)
            }
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

extension UI.View.Mask : IUIViewReusable {
    
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

extension UI.View.Mask : IUIViewDynamicSizeable {
}

extension UI.View.Mask : IUIViewBorderable {
}

extension UI.View.Mask : IUIViewCornerRadiusable {
}

extension UI.View.Mask : IUIViewShadowable {
}

extension UI.View.Mask : IUIViewColorable {
}

extension UI.View.Mask : IUIViewAlphable {
}
