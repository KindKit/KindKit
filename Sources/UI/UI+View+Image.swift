//
//  KindKit
//

import Foundation

public extension UI.View {

    final class Image {
        
        public private(set) unowned var appearedLayout: IUILayout?
        public unowned var appearedItem: UI.Layout.Item?
        public var size: UI.Size.Dynamic = .init(width: .fit, height: .fit) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var aspectRatio: Float? {
            didSet {
                guard self.aspectRatio != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var image: UI.Image? {
            didSet {
                guard self.image != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(image: self.image)
                }
                self.setNeedForceLayout()
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
        public var tintColor: UI.Color? {
            didSet {
                guard self.tintColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(tintColor: self.tintColor)
                }
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
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }

    }
    
}

public extension UI.View.Image {
    
    @inlinable
    @discardableResult
    func image(_ value: UI.Image?) -> Self {
        self.image = value
        return self
    }
    
    @inlinable
    @discardableResult
    func mode(_ value: Mode) -> Self {
        self.mode = value
        return self
    }
    
    @inlinable
    @discardableResult
    func tintColor(_ value: UI.Color?) -> Self {
        self.tintColor = value
        return self
    }
    
}

extension UI.View.Image : IUIView {
    
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
        guard let image = self.image else { return .zero }
        guard self.isHidden == false else { return .zero }
        return self.size.apply(
            available: available,
            sizeWithWidth: {
                switch self.mode {
                case .origin:
                    if let aspectRatio = self.aspectRatio {
                        return .init(width: $0, height: $0 / aspectRatio)
                    }
                    return image.size
                case .aspectFit, .aspectFill:
                    let aspectRatio = self.aspectRatio ?? image.size.aspectRatio
                    return .init(width: $0, height: $0 / aspectRatio)
                }
            },
            sizeWithHeight: {
                switch self.mode {
                case .origin:
                    if let aspectRatio = self.aspectRatio {
                        return .init(width: $0 * aspectRatio, height: $0)
                    }
                    return image.size
                case .aspectFit, .aspectFill:
                    let aspectRatio = self.aspectRatio ?? image.size.aspectRatio
                    return .init(width: $0 * aspectRatio, height: $0)
                }
            },
            size: {
                switch self.mode {
                case .origin:
                    if let aspectRatio = self.aspectRatio {
                        if available.width.isInfinite == true && available.height.isInfinite == false {
                            return .init(
                                width: available.height * aspectRatio,
                                height: available.height
                            )
                        } else if available.width.isInfinite == false && available.height.isInfinite == true {
                            return .init(
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
                        return .init(
                            width: available.height * aspectRatio,
                            height: available.height
                        )
                    } else if available.height.isInfinite == true {
                        let aspectRatio = image.size.aspectRatio
                        return .init(
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

extension UI.View.Image : IUIViewReusable {
    
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

extension UI.View.Image : IUIViewDynamicSizeable {
}

extension UI.View.Image : IUIViewAspectSizeable {
}

extension UI.View.Image : IUIViewColorable {
}

extension UI.View.Image : IUIViewTintColorable {
}

extension UI.View.Image : IUIViewAlphable {
}
