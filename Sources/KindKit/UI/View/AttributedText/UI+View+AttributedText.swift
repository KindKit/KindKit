//
//  KindKit
//

import Foundation

protocol KKAttributedTextViewDelegate : AnyObject {
    
    func shouldTap(_ view: KKAttributedTextView) -> Bool
    func tap(_ view: KKAttributedTextView, attributes: [NSAttributedString.Key: Any]?)
    
}

public extension UI.View {

    final class AttributedText {
        
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
                self._cacheAvailable = nil
                self._cacheSize = nil
                self.setNeedForceLayout()
            }
        }
        public var text: NSAttributedString? {
            didSet {
                guard self.text != oldValue else { return }
                self._cacheAvailable = nil
                self._cacheSize = nil
                if self.isLoaded == true {
                    self._view.update(text: self.text, alignment: self.alignment)
                }
                self.setNeedForceLayout()
            }
        }
        public var alignment: UI.Text.Alignment? {
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
                self.setNeedForceLayout()
            }
        }
        public var numberOfLines: UInt = 0 {
            didSet {
                guard self.numberOfLines != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(numberOfLines: self.numberOfLines)
                }
                self.setNeedForceLayout()
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
                self.setNeedForceLayout()
            }
        }
        public private(set) var isVisible: Bool = false
        public let onAppear: Signal.Empty< Void > = .init()
        public let onDisappear: Signal.Empty< Void > = .init()
        public let onVisible: Signal.Empty< Void > = .init()
        public let onVisibility: Signal.Empty< Void > = .init()
        public let onInvisible: Signal.Empty< Void > = .init()
        public let onTap: Signal.Args< Void, [NSAttributedString.Key: Any]? > = .init()
        
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

public extension UI.View.AttributedText {
    
    @inlinable
    @discardableResult
    func text(_ value: NSAttributedString?) -> Self {
        self.text = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: UI.Text.Alignment?) -> Self {
        self.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func lineBreak(_ value: UI.Text.LineBreak) -> Self {
        self.lineBreak = value
        return self
    }
    
    @inlinable
    @discardableResult
    func numberOfLines(_ value: UInt) -> Self {
        self.numberOfLines = value
        return self
    }
    
}

public extension UI.View.AttributedText {
    
    @inlinable
    @discardableResult
    func onTap(_ closure: (() -> Void)?) -> Self {
        self.onTap.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTap(_ closure: ((Self) -> Void)?) -> Self {
        self.onTap.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTap(_ closure: (([NSAttributedString.Key: Any]?) -> Void)?) -> Self {
        self.onTap.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTap(_ closure: ((Self, [NSAttributedString.Key: Any]?) -> Void)?) -> Self {
        self.onTap.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTap< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onTap.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTap< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, [NSAttributedString.Key: Any]?) -> Void)?) -> Self {
        self.onTap.link(sender, closure)
        return self
    }
    
}

extension UI.View.AttributedText : IUIView {
    
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
        if let cacheAvailable = self._cacheAvailable, let cacheSize = self._cacheSize {
            if cacheAvailable == available {
                return cacheSize
            } else {
                self._cacheAvailable = nil
                self._cacheSize = nil
            }
        }
        let size = self.size.apply(
            available: available,
            size: {
                guard let text = self.text else { return .zero }
                return text.kk_size(
                    numberOfLines: self.numberOfLines,
                    available: $0
                )
            }
        )
        self._cacheAvailable = available
        self._cacheSize = size
        return size
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

extension UI.View.AttributedText : IUIViewReusable {
    
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

extension UI.View.AttributedText : IUIViewTransformable {
}

#endif

extension UI.View.AttributedText : IUIViewDynamicSizeable {
}

extension UI.View.AttributedText : IUIViewColorable {
}

extension UI.View.AttributedText : IUIViewAlphable {
}

extension UI.View.AttributedText : KKAttributedTextViewDelegate {
    
    func shouldTap(_ view: KKAttributedTextView) -> Bool {
        return self.onTap.isEmpty == false
    }
    
    func tap(_ view: KKAttributedTextView, attributes: [NSAttributedString.Key: Any]?) {
        self.onTap.emit(attributes)
    }
    
}

public extension IUIView where Self == UI.View.AttributedText {
    
    @inlinable
    static func attributedText() -> Self {
        return .init()
    }
    
}
