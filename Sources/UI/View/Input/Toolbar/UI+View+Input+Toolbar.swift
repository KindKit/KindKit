//
//  KindKit
//

#if os(iOS)

import UIKit

protocol KKInputToolbarViewDelegate : AnyObject {
    
    func pressed(_ view: KKInputToolbarView, barItem: UIBarButtonItem)
    
}

public extension UI.View.Input {

    final class Toolbar {
        
        public private(set) weak var parentView: IUIView?
        public var items: [IInputToolbarItem] = [] {
            didSet {
                if self.isLoaded == true {
                    self._view.update(items: self.items)
                }
            }
        }
        public var size: Double = 55 {
            didSet {
                guard self.size != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(size: self.size)
                }
            }
        }
        public var isTranslucent: Bool = false {
            didSet {
                guard self.isTranslucent != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(translucent: self.isTranslucent)
                }
            }
        }
        public var barTintColor: UI.Color? {
            didSet {
                guard self.barTintColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(barTintColor: self.barTintColor)
                }
            }
        }
        public var contentTintColor: UI.Color = .white {
            didSet {
                guard self.contentTintColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(contentTintColor: self.contentTintColor)
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
        public let onAppear: Signal.Empty< Void > = .init()
        public let onDisappear: Signal.Empty< Void > = .init()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }
        
    }
    
}

public extension UI.View.Input.Toolbar {
    
    @inlinable
    @discardableResult
    func items(_ value: [IInputToolbarItem]) -> Self {
        self.items = value
        return self
    }
    
    @inlinable
    @discardableResult
    func size(available value: Double) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func translucent(_ value: Bool) -> Self {
        self.isTranslucent = value
        return self
    }
    
    @inlinable
    @discardableResult
    func barTintColor(_ value: UI.Color?) -> Self {
        self.barTintColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func contentTintColor(_ value: UI.Color) -> Self {
        self.contentTintColor = value
        return self
    }
    
}

extension UI.View.Input.Toolbar : IUIAccessoryView {
    
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
        return .init(width: available.width, height: self.size)
    }
    
    public func appear(to view: IUIView) {
        self.parentView = view
        self.onAppear.emit()
    }
    
    public func disappear() {
        self._reuse.disappear()
        self.parentView = nil
        self.onDisappear.emit()
    }
    
}

extension UI.View.Input.Toolbar : IUIViewReusable {
    
    public var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour {
        set { self._reuse.unloadBehaviour = newValue }
        get { self._reuse.unloadBehaviour }
    }
    
    public var reuseCache: UI.Reuse.Cache? {
        set { self._reuse.cache = newValue }
        get { self._reuse.cache }
    }
    
    public var reuseName: Swift.String? {
        set { self._reuse.name = newValue }
        get { self._reuse.name }
    }
    
}

extension UI.View.Input.Toolbar : IUIViewColorable {
}

extension UI.View.Input.Toolbar : KKInputToolbarViewDelegate {
    
    func pressed(_ view: KKInputToolbarView, barItem: UIBarButtonItem) {
        guard let appearedItem = self.items.first(where: { return $0.barItem == barItem }) else { return }
        appearedItem.pressed()
    }
    
}

public extension IUIAccessoryView where Self == UI.View.Input.Toolbar {
    
    @inlinable
    static func inputToolbar() -> Self {
        return .init()
    }
    
}

#endif
