//
//  KindKit
//

#if os(iOS)

import Foundation

public extension UI.View {
    
    final class AnimatedImage : IUIView, IUIViewReusable, IUIViewDynamicSizeable, IUIViewAnimatable, IUIViewColorable, IUIViewTintColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
        public var isAnimating: Bool {
            set {
                if newValue == true {
                    self._view.startAnimating()
                } else if self.isLoaded == true {
                    self._view.stopAnimating()
                }
            }
            get {
                guard self.isLoaded == true else { return false }
                return self._view.isAnimating
            }
        }
        public var color: UI.Color? = nil {
            didSet {
                guard self.color != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(color: self.color)
                }
            }
        }
        public var tintColor: UI.Color? = nil {
            didSet {
                guard self.tintColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(tintColor: self.tintColor)
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
        public var aspectRatio: Float? = nil {
            didSet {
                guard self.aspectRatio != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var images: [UI.Image] = [] {
            didSet {
                guard self.images != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(images: self.images)
                }
                self.setNeedForceLayout()
            }
        }
        public var duration: TimeInterval = 1 {
            didSet {
                guard self.duration != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(duration: self.duration)
                }
            }
        }
        public var `repeat`: Repeat = .infinity {
            didSet {
                guard self.repeat != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(repeat: self.repeat)
                }
            }
        }
        public var mode: Mode = .aspectFit {
            didSet {
                guard self.mode != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(mode: self.mode)
                }
                self.setNeedForceLayout()
            }
        }
        public var onAppear: ((UI.View.AnimatedImage) -> Void)?
        public var onDisappear: ((UI.View.AnimatedImage) -> Void)?
        public var onVisible: ((UI.View.AnimatedImage) -> Void)?
        public var onVisibility: ((UI.View.AnimatedImage) -> Void)?
        public var onInvisible: ((UI.View.AnimatedImage) -> Void)?
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { return self._reuse.content }
        
        public init() {
        }
        
        public convenience init(
            configure: (UI.View.AnimatedImage) -> Void
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
            guard let image = self.images.first else { return .zero }
            return UI.Size.Dynamic.apply(
                available: available,
                width: self.width,
                height: self.height,
                sizeWithWidth: {
                    switch self.mode {
                    case .origin:
                        if let aspectRatio = self.aspectRatio {
                            return Size(width: $0, height: $0 / aspectRatio)
                        }
                        return image.size
                    case .aspectFit, .aspectFill:
                        let aspectRatio = self.aspectRatio ?? image.size.aspectRatio
                        return Size(width: $0, height: $0 / aspectRatio)
                    }
                },
                sizeWithHeight: {
                    switch self.mode {
                    case .origin:
                        if let aspectRatio = self.aspectRatio {
                            return Size(width: $0 * aspectRatio, height: $0)
                        }
                        return image.size
                    case .aspectFit, .aspectFill:
                        let aspectRatio = self.aspectRatio ?? image.size.aspectRatio
                        return Size(width: $0 * aspectRatio, height: $0)
                    }
                },
                size: {
                    switch self.mode {
                    case .origin:
                        if let aspectRatio = self.aspectRatio {
                            if available.width.isInfinite == true && available.height.isInfinite == false {
                                return Size(
                                    width: available.height * aspectRatio,
                                    height: available.height
                                )
                            } else if available.width.isInfinite == false && available.height.isInfinite == true {
                                return Size(
                                    width: available.width,
                                    height: available.width / aspectRatio
                                )
                            }
                        }
                        return image.size
                    case .aspectFit, .aspectFill:
                        if available.isInfinite == true {
                            return image.size
                        } else if available.width.isInfinite == true {
                            let aspectRatio = image.size.aspectRatio
                            return Size(
                                width: available.height * aspectRatio,
                                height: available.height
                            )
                        } else if available.height.isInfinite == true {
                            let aspectRatio = image.size.aspectRatio
                            return Size(
                                width: available.width,
                                height: available.width / aspectRatio
                            )
                        }
                        return image.size.aspectFit(available)
                    }
                }
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
        
    }
    
}

public extension UI.View.AnimatedImage {
    
    @inlinable
    @discardableResult
    func aspectRatio(_ value: Float?) -> Self {
        self.aspectRatio = value
        return self
    }
    
    @inlinable
    @discardableResult
    func images(_ value: [UI.Image]) -> Self {
        self.images = value
        return self
    }
    
    @inlinable
    @discardableResult
    func duration(_ value: TimeInterval) -> Self {
        self.duration = value
        return self
    }
    
    @inlinable
    @discardableResult
    func `repeat`(_ value: Repeat) -> Self {
        self.repeat = value
        return self
    }
    
    @inlinable
    @discardableResult
    func mode(_ value: Mode) -> Self {
        self.mode = value
        return self
    }
    
}

public extension UI.View.AnimatedImage {
    
    @discardableResult
    func onAppear(_ value: ((UI.View.AnimatedImage) -> Void)?) -> Self {
        self.onAppear = value
        return self
    }
    
    @discardableResult
    func onDisappear(_ value: ((UI.View.AnimatedImage) -> Void)?) -> Self {
        self.onDisappear = value
        return self
    }
    
    @discardableResult
    func onVisible(_ value: ((UI.View.AnimatedImage) -> Void)?) -> Self {
        self.onVisible = value
        return self
    }
    
    @discardableResult
    func onVisibility(_ value: ((UI.View.AnimatedImage) -> Void)?) -> Self {
        self.onVisibility = value
        return self
    }
    
    @discardableResult
    func onInvisible(_ value: ((UI.View.AnimatedImage) -> Void)?) -> Self {
        self.onInvisible = value
        return self
    }
    
}

#endif
