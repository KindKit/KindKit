//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

protocol InputToolbarViewDelegate : AnyObject {
    
    func pressed(barItem: UIBarButtonItem)
    
}

public struct InputToolbarActionItem : IInputToolbarItem {
    
    public var barItem: UIBarButtonItem
    public var callback: () -> Void
    
    public init(
        text: String,
        callback: @escaping () -> Void
    ) {
        self.callback = callback
        self.barItem = UIBarButtonItem(title: text, style: .plain, target: nil, action: nil)
    }
    
    public init(
        image: Image,
        callback: @escaping () -> Void
    ) {
        self.callback = callback
        self.barItem = UIBarButtonItem(image: image.native, style: .plain, target: nil, action: nil)
    }
    
    public init(
        systemItem: UIBarButtonItem.SystemItem,
        callback: @escaping () -> Void
    ) {
        self.callback = callback
        self.barItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
    }
    
    public func pressed() {
        self.callback()
    }
    
}

public struct InputToolbarFlexibleSpaceItem : IInputToolbarItem {
    
    public var barItem: UIBarButtonItem
    
    public init() {
        self.barItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    public func pressed() {
    }
    
}

open class InputToolbarView : IInputToolbarView {
    
    public private(set) unowned var parentView: IView?
    public var native: NativeView {
        return self._view
    }
    public var isLoaded: Bool {
        return self._reuse.isLoaded
    }
    public var bounds: RectFloat {
        guard self.isLoaded == true else { return .zero }
        return RectFloat(self._view.bounds)
    }
    public var items: [IInputToolbarItem] {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(items: self.items)
        }
    }
    public var size: Float {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(size: self.size)
        }
    }
    public var isTranslucent: Bool {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(translucent: self.isTranslucent)
        }
    }
    public var barTintColor: Color? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(barTintColor: self.barTintColor)
        }
    }
    public var contentTintColor: Color {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(contentTintColor: self.contentTintColor)
        }
    }
    public var color: Color? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(color: self.color)
        }
    }
    
    private var _reuse: ReuseItem< Reusable >
    private var _view: Reusable.Content {
        return self._reuse.content()
    }
    private var _onAppear: (() -> Void)?
    private var _onDisappear: (() -> Void)?
    
    public init(
        items: [IInputToolbarItem],
        size: Float = 55,
        isTranslucent: Bool = false,
        barTintColor: Color? = nil,
        contentTintColor: Color = Color(rgb: 0xffffff),
        color: Color? = nil
    ) {
        self.items = items
        self.size = size
        self.isTranslucent = isTranslucent
        self.barTintColor = barTintColor
        self.contentTintColor = contentTintColor
        self.color = color
        self._reuse = ReuseItem()
        self._reuse.configure(owner: self)
    }
    
    deinit {
        self._reuse.destroy()
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        return SizeFloat(width: available.width, height: self.size)
    }
    
    public func appear(to view: IView) {
        self.parentView = view
        self._onAppear?()
    }
    
    public func disappear() {
        self._reuse.disappear()
        self.parentView = nil
        self._onDisappear?()
    }
    
    @discardableResult
    public func items(_ value: [IInputToolbarItem]) -> Self {
        self.items = value
        return self
    }
    
    @discardableResult
    public func size(available value: Float) -> Self {
        self.size = value
        return self
    }
    
    @discardableResult
    public func translucent(_ value: Bool) -> Self {
        self.isTranslucent = value
        return self
    }
    
    @discardableResult
    public func barTintColor(_ value: Color?) -> Self {
        self.barTintColor = value
        return self
    }
    
    @discardableResult
    public func contentTintColor(_ value: Color) -> Self {
        self.contentTintColor = value
        return self
    }
    
    @discardableResult
    public func color(_ value: Color?) -> Self {
        self.color = value
        return self
    }
    
    @discardableResult
    public func onAppear(_ value: (() -> Void)?) -> Self {
        self._onAppear = value
        return self
    }
    
    @discardableResult
    public func onDisappear(_ value: (() -> Void)?) -> Self {
        self._onDisappear = value
        return self
    }
    
}

extension InputToolbarView : InputToolbarViewDelegate {
    
    func pressed(barItem: UIBarButtonItem) {
        guard let item = self.items.first(where: { return $0.barItem == barItem }) else { return }
        item.pressed()
    }
    
}

#endif
