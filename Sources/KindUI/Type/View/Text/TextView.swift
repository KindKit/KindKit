//
//  KindKit
//

import KindEvent
import KindGraphics
import KindMath

public final class TextView {
    
    public private(set) weak var appearedLayout: ILayout?
    public var frame: Rect = .zero {
        didSet {
            guard self.frame != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(frame: self.frame)
            }
        }
    }
#if os(iOS)
    public var transform: Transform = .init() {
        didSet {
            guard self.transform != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(transform: self.transform)
            }
        }
    }
#endif
    public var size: DynamicSize = .init(.fit, .fit) {
        didSet {
            guard self.size != oldValue else { return }
            self.setNeedLayout()
        }
    }
    public var text: String = "" {
        didSet {
            guard self.text != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(text: self.text)
            }
            self._cacheAvailable = nil
            self._cacheSize = nil
            self.setNeedLayout()
        }
    }
    public var textFont: Font = .init(weight: .regular) {
        didSet {
            guard self.textFont != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(textFont: self.textFont)
            }
            self._cacheAvailable = nil
            self._cacheSize = nil
            self.setNeedLayout()
        }
    }
    public var textColor: Color = .black {
        didSet {
            guard self.textColor != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(textColor: self.textColor)
            }
        }
    }
    public var alignment: Text.Alignment = .left {
        didSet {
            guard self.alignment != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(alignment: self.alignment)
            }
            self.setNeedLayout()
        }
    }
    public var lineBreak: Text.LineBreak = .wordWrapping {
        didSet {
            guard self.lineBreak != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(lineBreak: self.lineBreak)
            }
            self.setNeedLayout()
        }
    }
    public var numberOfLines: UInt = 0 {
        didSet {
            guard self.numberOfLines != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(numberOfLines: self.numberOfLines)
            }
            self.setNeedLayout()
        }
    }
    public var color: Color? = .clear {
        didSet {
            guard self.color != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(color: self.color)
            }
        }
    }
    public var alpha: Double = 1 {
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
            self.setNeedLayout()
        }
    }
    public private(set) var isVisible: Bool = false
    public let onAppear = Signal< Void, Void >()
    public let onDisappear = Signal< Void, Void >()
    public let onVisible = Signal< Void, Void >()
    public let onInvisible = Signal< Void, Void >()
    
    private lazy var _reuse: Reuse.Item< Reusable > = .init(owner: self)
    @inline(__always) private var _view: Reusable.Content { self._reuse.content }
    private var _cacheAvailable: Size?
    private var _cacheSize: Size?
    
    public init() {
    }
    
    deinit {
        self._reuse.destroy()
    }

}

extension TextView : IView {
    
    public var native: NativeView {
        self._view
    }
    
    public var isLoaded: Bool {
        self._reuse.isLoaded
    }
    
    public var bounds: Rect {
        guard self.isLoaded == true else { return .zero }
        return .init(self._view.bounds)
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: Size) -> Size {
        guard self.isHidden == false else { return .zero }
        return self.size.apply(
            available: available,
            size: {
                if let cacheAvailable = self._cacheAvailable, let cacheSize = self._cacheSize {
                    if cacheAvailable == available {
                        return cacheSize
                    } else {
                        self._cacheAvailable = nil
                        self._cacheSize = nil
                    }
                }
                let size = self.text.kk_size(
                    font: self.textFont,
                    numberOfLines: self.numberOfLines,
                    available: $0
                )
                self._cacheAvailable = available
                self._cacheSize = size
                return size
            }
        )
    }
    
    public func appear(to layout: ILayout) {
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
    
    public func invisible() {
        self.isVisible = false
        self.onInvisible.emit()
    }
    
}

extension TextView : IViewReusable {
    
    public var reuseUnloadBehaviour: Reuse.UnloadBehaviour {
        set { self._reuse.unloadBehaviour = newValue }
        get { self._reuse.unloadBehaviour }
    }
    
    public var reuseCache: ReuseCache? {
        set { self._reuse.cache = newValue }
        get { self._reuse.cache }
    }
    
    public var reuseName: String? {
        set { self._reuse.name = newValue }
        get { self._reuse.name }
    }
    
}

#if os(iOS)

extension TextView : IViewTransformable {
}

#endif

extension TextView : IViewDynamicSizeable {
}

extension TextView : IViewTextPlainable {
}

extension TextView : IViewColorable {
}

extension TextView : IViewAlphable {
}
