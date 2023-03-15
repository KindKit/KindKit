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
        public var tintColor: UI.Color? = .system {
            didSet {
                guard self.tintColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(tintColor: self.tintColor)
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

extension UI.View.Input.Toolbar : IUIViewTintColorable {
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

fileprivate extension UI.Color {
    
    static var system: Self {
        if #available(iOS 13.0, *) {
            return .init(.label)
        }
        return .init(.black)
    }
    
}

#endif
