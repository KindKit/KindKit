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
    
    final class Control {
        
        public private(set) unowned var appearedLayout: IUILayout?
        public unowned var appearedItem: UI.Layout.Item?
        public var size: UI.Size.Dynamic = .init(width: .fit, height: .fit) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var content: IUILayout? {
            willSet {
                guard self.content !== newValue else { return }
                self.content?.view = nil
            }
            didSet {
                guard self.content !== oldValue else { return }
                self.content?.view = self
                if self.isLoaded == true {
                    self._view.update(content: self.content)
                }
                self.content?.setNeedForceUpdate()
                self.setNeedForceLayout()
            }
        }
        public var contentSize: SizeFloat {
            guard self.isLoaded == true else { return .zero }
            return self._view.contentSize
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
        public var shouldPressed: Bool = false
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
        public let onStyle: Signal.Args< Void, Bool > = .init()
        public let onPressed: Signal.Empty< Void > = .init()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        private var _isHighlighted: Bool = false
        private var _isLocked: Bool = false
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
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

extension UI.View.Control : IUIView {
    
    public var native: NativeView {
        return self._view
    }
    
    public var isLoaded: Bool {
        return self._reuse.isLoaded
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

extension UI.View.Control : IUIViewReusable {
    
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

extension UI.View.Control :  IUIViewDynamicSizeable{
}

extension UI.View.Control : IUIViewColorable {
}

extension UI.View.Control : IUIViewAlphable {
}

extension UI.View.Control : IUIViewHighlightable {
}

extension UI.View.Control : IUIViewLockable {
}

extension UI.View.Control : IUIViewPressable {
}

extension UI.View.Control : KKControlViewDelegate {
    
    func shouldHighlighting(_ view: KKControlView) -> Bool {
        return self.shouldHighlighting
    }
    
    func set(_ view: KKControlView, highlighted: Bool) {
        if self._isHighlighted != highlighted {
            self._isHighlighted = highlighted
            self.onStyle.emit(true)
        }
    }
    
    func shouldPressing(_ view: KKControlView) -> Bool {
        return self.shouldPressed
    }
    
    func pressed(_ view: KKControlView) {
        self.onPressed.emit()
    }
    
}
