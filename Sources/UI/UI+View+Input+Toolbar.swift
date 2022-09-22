//
//  KindKit
//

#if os(iOS)

import UIKit

protocol KKInputToolbarViewDelegate : AnyObject {
    
    func pressed(_ view: KKInputToolbarView, barItem: UIBarButtonItem)
    
}

public extension UI.View.Input {

    final class Toolbar : IUIAccessoryView, IUIViewColorable {
        
        public private(set) unowned var parentView: IUIView?
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
        public var items: [IInputToolbarItem] {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(items: self.items)
            }
        }
        public var size: Float = 55 {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(size: self.size)
            }
        }
        public var isTranslucent: Bool = false {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(translucent: self.isTranslucent)
            }
        }
        public var barTintColor: Color? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(barTintColor: self.barTintColor)
            }
        }
        public var contentTintColor: Color = .init(rgb: 0xffffff) {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(contentTintColor: self.contentTintColor)
            }
        }
        public var color: Color? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(color: self.color)
            }
        }
        
        private var _reuse: UI.Reuse.Item< Reusable >
        private var _view: Reusable.Content {
            return self._reuse.content()
        }
        private var _onAppear: ((UI.View.Input.Toolbar) -> Void)?
        private var _onDisappear: ((UI.View.Input.Toolbar) -> Void)?
        
        public init(
            _ items: [IInputToolbarItem]
        ) {
            self.items = items
            self._reuse = UI.Reuse.Item()
            self._reuse.configure(owner: self)
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
            self._onAppear?(self)
        }
        
        public func disappear() {
            self._reuse.disappear()
            self.parentView = nil
            self._onDisappear?(self)
        }
        
        @discardableResult
        public func onAppear(_ value: ((UI.View.Input.Toolbar) -> Void)?) -> Self {
            self._onAppear = value
            return self
        }
        
        @discardableResult
        public func onDisappear(_ value: ((UI.View.Input.Toolbar) -> Void)?) -> Self {
            self._onDisappear = value
            return self
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
    func barTintColor(_ value: Color?) -> Self {
        self.barTintColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func contentTintColor(_ value: Color) -> Self {
        self.contentTintColor = value
        return self
    }
    
}

extension UI.View.Input.Toolbar : KKInputToolbarViewDelegate {
    
    func pressed(_ view: KKInputToolbarView, barItem: UIBarButtonItem) {
        guard let item = self.items.first(where: { return $0.barItem == barItem }) else { return }
        item.pressed()
    }
    
}

#endif