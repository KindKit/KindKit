//
//  KindKit
//

import Foundation

public extension UI.View {

    final class Text : IUIView, IUIViewReusable, IUIViewDynamicSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
        public private(set) unowned var appearedLayout: IUILayout?
        public unowned var appearedItem: UI.Layout.Item?
        public private(set) var isVisible: Bool = false
        public var isHidden: Bool = false {
            didSet(oldValue) {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour {
            set(value) { self._reuse.unloadBehaviour = value }
            get { return self._reuse.unloadBehaviour }
        }
        public var reuseCache: UI.Reuse.Cache? {
            set(value) { self._reuse.cache = value }
            get { return self._reuse.cache }
        }
        public var reuseName: String? {
            set(value) { self._reuse.name = value }
            get { return self._reuse.name }
        }
        public var color: UI.Color? = .clear {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(color: self.color)
            }
        }
        public var border: UI.Border = .none {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(border: self.border)
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(cornerRadius: self.cornerRadius)
                self._view.updateShadowPath()
            }
        }
        public var shadow: UI.Shadow? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(shadow: self.shadow)
                self._view.updateShadowPath()
            }
        }
        public var alpha: Float = 1 {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(alpha: self.alpha)
            }
        }
        public var width: UI.Size.Dynamic = .fit {
            didSet {
                guard self.width != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._cacheAvailable = nil
                self._cacheSize = nil
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Dynamic = .fit {
            didSet {
                guard self.height != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._cacheAvailable = nil
                self._cacheSize = nil
                self.setNeedForceLayout()
            }
        }
        public var text: String {
            didSet {
                guard self.text != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(text: self.text)
                self._cacheAvailable = nil
                self._cacheSize = nil
                self.setNeedForceLayout()
            }
        }
        public var textFont: UI.Font = .init(weight: .regular) {
            didSet {
                guard self.textFont != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(textFont: self.textFont)
                self._cacheAvailable = nil
                self._cacheSize = nil
                self.setNeedForceLayout()
            }
        }
        public var textColor: UI.Color = .black {
            didSet {
                guard self.textColor != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(textColor: self.textColor)
            }
        }
        public var alignment: UI.Text.Alignment = .left {
            didSet {
                guard self.alignment != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(alignment: self.alignment)
                self.setNeedLayout()
            }
        }
        public var lineBreak: UI.Text.LineBreak = .wordWrapping {
            didSet {
                guard self.lineBreak != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(lineBreak: self.lineBreak)
                self.setNeedForceLayout()
            }
        }
        public var numberOfLines: UInt = 0 {
            didSet {
                guard self.numberOfLines != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(numberOfLines: self.numberOfLines)
                self.setNeedForceLayout()
            }
        }
        public var onAppear: ((UI.View.Text) -> Void)?
        public var onDisappear: ((UI.View.Text) -> Void)?
        public var onVisible: ((UI.View.Text) -> Void)?
        public var onVisibility: ((UI.View.Text) -> Void)?
        public var onInvisible: ((UI.View.Text) -> Void)?
        
        private var _reuse: UI.Reuse.Item< Reusable >
        private var _view: Reusable.Content {
            return self._reuse.content
        }
        private var _cacheAvailable: SizeFloat?
        private var _cacheSize: SizeFloat?
        
        public init(
            _ text: String
        ) {
            self.text = text
            self._reuse = UI.Reuse.Item()
            self._reuse.configure(owner: self)
        }
        
        public convenience init(
            text: String,
            configure: (UI.View.Text) -> Void
        ) {
            self.init(text)
            self.modify(configure)
        }
        
        deinit {
            self._reuse.destroy()
        }
        
        public func loadIfNeeded() {
            self._reuse.loadIfNeeded()
        }
        
        public func size(available: SizeFloat) -> SizeFloat {
            guard self.isHidden == false else { return .zero }
            if let cacheAvailable = self._cacheAvailable, let cacheSize = self._cacheSize {
                if cacheAvailable == available {
                    return cacheSize
                } else {
                    self._cacheAvailable = nil
                    self._cacheSize = nil
                }
            }
            let size = UI.Size.Dynamic.apply(
                available: available,
                width: self.width,
                height: self.height,
                sizeWithWidth: { self.text.size(font: self.textFont, available: Size(width: $0, height: .infinity)) },
                sizeWithHeight: { self.text.size(font: self.textFont, available: Size(width: .infinity, height: $0)) },
                size: { self.text.size(font: self.textFont, available: available) }
            )
            self._cacheAvailable = available
            self._cacheSize = size
            return size
        }
        
        public func appear(to layout: IUILayout) {
            self.appearedLayout = layout
            self.onAppear?(self)
        }
        
        public func disappear() {
            self._reuse.disappear()
            self.appearedLayout = nil
            self.onDisappear?(self)
        }
        
        public func visible() {
            self.isVisible = true
            self.onVisible?(self)
        }
        
        public func visibility() {
            self.onVisibility?(self)
        }
        
        public func invisible() {
            self.isVisible = false
            self.onInvisible?(self)
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
    func textFont(_ value: UI.Font) -> Self {
        self.textFont = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: UI.Color) -> Self {
        self.textColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: UI.Text.Alignment) -> Self {
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

public extension UI.View.Text {
    
    @inlinable
    @discardableResult
    func onAppear(_ value: ((UI.View.Text) -> Void)?) -> Self {
        self.onAppear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ value: ((UI.View.Text) -> Void)?) -> Self {
        self.onDisappear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ value: ((UI.View.Text) -> Void)?) -> Self {
        self.onVisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ value: ((UI.View.Text) -> Void)?) -> Self {
        self.onVisibility = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ value: ((UI.View.Text) -> Void)?) -> Self {
        self.onInvisible = value
        return self
    }
    
}
