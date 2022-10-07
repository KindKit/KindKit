//
//  KindKit
//

#if os(iOS)

import UIKit

protocol KKInputToolbarViewDelegate : AnyObject {
    
    func pressed(_ view: KKInputToolbarView, barItem: UIBarButtonItem)
    
}

public extension UI.View.Input {

    final class Toolbar : IUIAccessoryView, IUIViewReusable, IUIViewColorable {
        
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
        public private(set) unowned var parentView: IUIView?
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
        public var color: UI.Color? = nil {
            didSet {
                guard self.color != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(color: self.color)
                }
            }
        }
        public var items: [IInputToolbarItem] {
            didSet {
                if self.isLoaded == true {
                    self._view.update(items: self.items)
                }
            }
        }
        public var size: Float = 55 {
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
        public var barTintColor: UI.Color? = nil {
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
        public let onAppear: Signal.Empty< Void > = .init()
        public let onDisappear: Signal.Empty< Void > = .init()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { return self._reuse.content }
        
        public init(
            _ items: [IInputToolbarItem]
        ) {
            self.items = items
        }
        
        public convenience init(
            items: [IInputToolbarItem],
            configure: (UI.View.Input.Toolbar) -> Void
        ) {
            self.init(items)
            self.modify(configure)
        }
        
        deinit {
            self._reuse.destroy()
        }
        
        public func loadIfNeeded() {
            self._reuse.loadIfNeeded()
        }
        
        public func size(available: SizeFloat) -> SizeFloat {
            return Size(width: available.width, height: self.size)
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
    func size(available value: Float) -> Self {
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

extension UI.View.Input.Toolbar : KKInputToolbarViewDelegate {
    
    func pressed(_ view: KKInputToolbarView, barItem: UIBarButtonItem) {
        guard let appearedItem = self.items.first(where: { return $0.barItem == barItem }) else { return }
        appearedItem.pressed()
    }
    
}

#endif
