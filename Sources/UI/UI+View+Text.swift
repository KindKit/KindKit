//
//  KindKit
//

import Foundation

public extension UI.View {

    final class Text : IUIView, IUIViewDynamicSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public private(set) unowned var layout: IUILayout?
        public unowned var item: UI.Layout.Item?
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
        public private(set) var isVisible: Bool = false
        public var isHidden: Bool = false {
            didSet(oldValue) {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
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
        public var textFont: Font = Font(weight: .regular) {
            didSet {
                guard self.textFont != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(textFont: self.textFont)
                self._cacheAvailable = nil
                self._cacheSize = nil
                self.setNeedForceLayout()
            }
        }
        public var textColor: Color = Color(rgb: 0x000000) {
            didSet {
                guard self.textColor != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(textColor: self.textColor)
            }
        }
        public var alignment: TextAlignment = .left {
            didSet {
                guard self.alignment != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(alignment: self.alignment)
                self.setNeedLayout()
            }
        }
        public var lineBreak: TextLineBreak = .wordWrapping {
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
        public var color: Color? = Color(rgba: 0x00000000) {
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
        
        private var _reuse: UI.Reuse.Item< Reusable >
        private var _view: Reusable.Content {
            return self._reuse.content()
        }
        private var _onAppear: ((UI.View.Text) -> Void)?
        private var _onDisappear: ((UI.View.Text) -> Void)?
        private var _onVisible: ((UI.View.Text) -> Void)?
        private var _onVisibility: ((UI.View.Text) -> Void)?
        private var _onInvisible: ((UI.View.Text) -> Void)?
        private var _cacheAvailable: SizeFloat?
        private var _cacheSize: SizeFloat?
        
        public init(
            _ text: String
        ) {
            self.text = text
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
            self.layout = layout
            self._onAppear?(self)
        }
        
        public func disappear() {
            self._reuse.disappear()
            self.layout = nil
            self._onDisappear?(self)
        }
        
        public func visible() {
            self.isVisible = true
            self._onVisible?(self)
        }
        
        public func visibility() {
            self._onVisibility?(self)
        }
        
        public func invisible() {
            self.isVisible = false
            self._onInvisible?(self)
        }
        
        @discardableResult
        public func onAppear(_ value: ((UI.View.Text) -> Void)?) -> Self {
            self._onAppear = value
            return self
        }
        
        @discardableResult
        public func onDisappear(_ value: ((UI.View.Text) -> Void)?) -> Self {
            self._onDisappear = value
            return self
        }
        
        @discardableResult
        public func onVisible(_ value: ((UI.View.Text) -> Void)?) -> Self {
            self._onVisible = value
            return self
        }
        
        @discardableResult
        public func onVisibility(_ value: ((UI.View.Text) -> Void)?) -> Self {
            self._onVisibility = value
            return self
        }
        
        @discardableResult
        public func onInvisible(_ value: ((UI.View.Text) -> Void)?) -> Self {
            self._onInvisible = value
            return self
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
    func textFont(_ value: Font) -> Self {
        self.textFont = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: Color) -> Self {
        self.textColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: TextAlignment) -> Self {
        self.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func lineBreak(_ value: TextLineBreak) -> Self {
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
