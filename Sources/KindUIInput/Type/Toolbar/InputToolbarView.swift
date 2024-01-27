//
//  KindKit
//

#if os(iOS)

import UIKit
import KindEvent
import KindGraphics
import KindMath

protocol KKInputToolbarViewDelegate : AnyObject {
    
    func pressed(_ view: KKInputToolbarView, barItem: UIBarButtonItem)
    
}

public final class InputToolbarView {
    
    public private(set) weak var parentView: IView?
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
    public var tintColor: Color? = .system {
        didSet {
            guard self.tintColor != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(tintColor: self.tintColor)
            }
        }
    }
    public let onAppear = Signal< Void, Void >()
    public let onDisappear = Signal< Void, Void >()
    
    private lazy var _reuse: Reuse.Item< Reusable > = .init(owner: self)
    @inline(__always) private var _view: Reusable.Content { self._reuse.content }
    
    public init() {
    }
    
    deinit {
        self._reuse.destroy()
    }
    
}

public extension InputToolbarView {
    
    @inlinable
    @discardableResult
    func items(_ value: [IInputToolbarItem]) -> Self {
        self.items = value
        return self
    }
    
    @inlinable
    @discardableResult
    func items(_ value: () -> [IInputToolbarItem]) -> Self {
        return self.items(value())
    }

    @inlinable
    @discardableResult
    func items(_ value: (Self) -> [IInputToolbarItem]) -> Self {
        return self.items(value(self))
    }
    
    @inlinable
    @discardableResult
    func size(_ value: Double) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func size(_ value: () -> Double) -> Self {
        return self.size(value())
    }

    @inlinable
    @discardableResult
    func size(_ value: (Self) -> Double) -> Self {
        return self.size(value(self))
    }
    
}

extension InputToolbarView : IAccessoryView {
    
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
    
    public func appear(to view: IView) {
        self.parentView = view
        self.onAppear.emit()
    }
    
    public func disappear() {
        self._reuse.disappear()
        self.parentView = nil
        self.onDisappear.emit()
    }
    
}

extension InputToolbarView : IViewReusable {
    
    public var reuseUnloadBehaviour: Reuse.UnloadBehaviour {
        set { self._reuse.unloadBehaviour = newValue }
        get { self._reuse.unloadBehaviour }
    }
    
    public var reuseCache: ReuseCache? {
        set { self._reuse.cache = newValue }
        get { self._reuse.cache }
    }
    
    public var reuseName: Swift.String? {
        set { self._reuse.name = newValue }
        get { self._reuse.name }
    }
    
}

extension InputToolbarView : IViewSupportTintColor {
}

extension InputToolbarView : KKInputToolbarViewDelegate {
    
    func pressed(_ view: KKInputToolbarView, barItem: UIBarButtonItem) {
        guard let appearedItem = self.items.first(where: { return $0.barItem == barItem }) else { return }
        appearedItem.pressed()
    }
    
}

fileprivate extension Color {
    
    static var system: Self {
        if #available(iOS 13.0, *) {
            return .init(.label)
        }
        return .init(.black)
    }
    
}

#endif
