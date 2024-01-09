//
//  KindKit
//

import Foundation

public extension UI.View {

    final class Text {
        
        public private(set) weak var appearedLayout: IUILayout?
        public var frame: KindKit.Rect = .zero {
            didSet {
                guard self.frame != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(frame: self.frame)
                }
            }
        }
#if os(iOS)
        public var transform: UI.Transform = .init() {
            didSet {
                guard self.transform != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(transform: self.transform)
                }
            }
        }
#endif
        public var size: UI.Size.Dynamic = .init(.fit, .fit) {
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
        public var textFont: UI.Font = .init(weight: .regular) {
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
        public var textColor: UI.Color = .black {
            didSet {
                guard self.textColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(textColor: self.textColor)
                }
            }
        }
        public var alignment: UI.Text.Alignment = .left {
            didSet {
                guard self.alignment != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(alignment: self.alignment)
                }
                self.setNeedLayout()
            }
        }
        public var lineBreak: UI.Text.LineBreak = .wordWrapping {
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
        public var color: UI.Color? = .clear {
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
        public let onAppear = Signal.Empty< Void >()
        public let onDisappear = Signal.Empty< Void >()
        public let onVisible = Signal.Empty< Void >()
        public let onInvisible = Signal.Empty< Void >()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        private var _cacheAvailable: Size?
        private var _cacheSize: Size?
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }

    }
    
}

public extension UI.View.Text {
    
    @inlinable
    @discardableResult
    func text(_ value: String) -> Self {
        self.text = value
        return self
    }
    
    @inlinable
    @discardableResult
    func text(_ value: () -> String) -> Self {
        return self.text(value())
    }

    @inlinable
    @discardableResult
    func text(_ value: (Self) -> String) -> Self {
        return self.text(value(self))
    }
    
    @inlinable
    @discardableResult
    func text< Localized : IEnumLocalized >(_ value: Localized) -> Self {
        self.text = value.localized
        return self
    }
    
    @inlinable
    @discardableResult
    func textFont(_ value: UI.Font) -> Self {
        self.textFont = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textFont(_ value: () -> UI.Font) -> Self {
        return self.textFont(value())
    }

    @inlinable
    @discardableResult
    func textFont(_ value: (Self) -> UI.Font) -> Self {
        return self.textFont(value(self))
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: UI.Color) -> Self {
        self.textColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: () -> UI.Color) -> Self {
        return self.textColor(value())
    }

    @inlinable
    @discardableResult
    func textColor(_ value: (Self) -> UI.Color) -> Self {
        return self.textColor(value(self))
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: UI.Text.Alignment) -> Self {
        self.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: () -> UI.Text.Alignment) -> Self {
        return self.alignment(value())
    }

    @inlinable
    @discardableResult
    func alignment(_ value: (Self) -> UI.Text.Alignment) -> Self {
        return self.alignment(value(self))
    }
    
    @inlinable
    @discardableResult
    func lineBreak(_ value: UI.Text.LineBreak) -> Self {
        self.lineBreak = value
        return self
    }
    
    @inlinable
    @discardableResult
    func lineBreak(_ value: () -> UI.Text.LineBreak) -> Self {
        return self.lineBreak(value())
    }

    @inlinable
    @discardableResult
    func lineBreak(_ value: (Self) -> UI.Text.LineBreak) -> Self {
        return self.lineBreak(value(self))
    }
    
    @inlinable
    @discardableResult
    func numberOfLines(_ value: UInt) -> Self {
        self.numberOfLines = value
        return self
    }
    
    @inlinable
    @discardableResult
    func numberOfLines(_ value: () -> UInt) -> Self {
        return self.numberOfLines(value())
    }

    @inlinable
    @discardableResult
    func numberOfLines(_ value: (Self) -> UInt) -> Self {
        return self.numberOfLines(value(self))
    }
    
}

extension UI.View.Text : IUIView {
    
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
    
    public func invisible() {
        self.isVisible = false
        self.onInvisible.emit()
    }
    
}

extension UI.View.Text : IUIViewReusable {
    
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

#if os(iOS)

extension UI.View.Text : IUIViewTransformable {
}

#endif

extension UI.View.Text : IUIViewDynamicSizeable {
}

extension UI.View.Text : IUIViewColorable {
}

extension UI.View.Text : IUIViewAlphable {
}

public extension IUIView where Self == UI.View.Text {
    
    @inlinable
    static func text(_ text: String) -> Self {
        return .init().text(text)
    }
    
    @inlinable
    static func text< Text : IEnumLocalized >(_ text: Text) -> Self {
        return .init().text(text)
    }
    
}
