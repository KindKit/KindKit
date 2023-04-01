//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

public extension UI.View {

    final class Shape {
        
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
        public var size: UI.Size.Static = .init(.fill, .fill) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var path: Path2? {
            didSet {
                guard self.path != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(path: self.path)
                }
            }
        }
        public var fill: Fill? {
            didSet {
                guard self.fill != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(fill: self.fill)
                }
            }
        }
        public var stroke: Stroke? {
            didSet {
                guard self.stroke != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(stroke: self.stroke)
                }
            }
        }
        public var line: Line = .init() {
            didSet {
                guard self.line != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(line: self.line)
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
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }

    }
    
}

public extension UI.View.Shape {
    
    @inlinable
    @discardableResult
    func path(_ value: Path2?) -> Self {
        self.path = value
        return self
    }
    
    @inlinable
    @discardableResult
    func path(_ value: () -> Path2?) -> Self {
        return self.path(value())
    }

    @inlinable
    @discardableResult
    func path(_ value: (Self) -> Path2?) -> Self {
        return self.path(value(self))
    }
    
    @inlinable
    @discardableResult
    func fill(_ value: Fill?) -> Self {
        self.fill = value
        return self
    }
    
    @inlinable
    @discardableResult
    func fill(_ value: () -> Fill?) -> Self {
        return self.fill(value())
    }

    @inlinable
    @discardableResult
    func fill(_ value: (Self) -> Fill?) -> Self {
        return self.fill(value(self))
    }
    
    @inlinable
    @discardableResult
    func stroke(_ value: Stroke?) -> Self {
        self.stroke = value
        return self
    }
    
    @inlinable
    @discardableResult
    func stroke(_ value: () -> Stroke?) -> Self {
        return self.stroke(value())
    }

    @inlinable
    @discardableResult
    func stroke(_ value: (Self) -> Stroke?) -> Self {
        return self.stroke(value(self))
    }
    
    @inlinable
    @discardableResult
    func line(_ value: Line) -> Self {
        self.line = value
        return self
    }
    
    @inlinable
    @discardableResult
    func line(_ value: () -> Line) -> Self {
        return self.line(value())
    }

    @inlinable
    @discardableResult
    func line(_ value: (Self) -> Line) -> Self {
        return self.line(value(self))
    }
    
}

extension UI.View.Shape : IUIView {
    
    public var native: NativeView {
        return self._view
    }
    
    public var isLoaded: Bool {
        return self._reuse.isLoaded
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
        return self.size.apply(available: available)
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

extension UI.View.Shape : IUIViewReusable {
    
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

extension UI.View.Shape : IUIViewTransformable {
}

#endif

extension UI.View.Shape : IUIViewStaticSizeable {
}

extension UI.View.Shape : IUIViewColorable {
}

extension UI.View.Shape : IUIViewAlphable {
}

public extension IUIView where Self == UI.View.Shape {
    
    @inlinable
    static func shape(_ path: Path2?) -> Self {
        return .init().path(path)
    }
    
}

#endif
