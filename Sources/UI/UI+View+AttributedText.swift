//
//  KindKit
//

import Foundation

protocol KKAttributedTextViewDelegate : AnyObject {
    
    func shouldTap(_ view: KKAttributedTextView) -> Bool
    func tap(_ view: KKAttributedTextView, attributes: [NSAttributedString.Key: Any]?)
    
}

public extension UI.View {

    final class AttributedText : IUIView, IUIViewDynamicSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public private(set) unowned var appearedLayout: IUILayout?
        public unowned var appearedItem: UI.Layout.Item?
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
            didSet(oldValue) {
                guard self.width != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._cacheAvailable = nil
                self._cacheSize = nil
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Dynamic = .fit {
            didSet(oldValue) {
                guard self.height != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._cacheAvailable = nil
                self._cacheSize = nil
                self.setNeedForceLayout()
            }
        }
        public var text: NSAttributedString {
            didSet(oldValue) {
                guard self.text != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(text: self.text, alignment: self.alignment)
                self._cacheAvailable = nil
                self._cacheSize = nil
                self.setNeedForceLayout()
            }
        }
        public var alignment: UI.Text.Alignment? = nil {
            didSet(oldValue) {
                guard self.alignment != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(alignment: self.alignment)
                self.setNeedLayout()
            }
        }
        public var lineBreak: UI.Text.LineBreak = .wordWrapping {
            didSet(oldValue) {
                guard self.lineBreak != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(lineBreak: self.lineBreak)
                self.setNeedForceLayout()
            }
        }
        public var numberOfLines: UInt = 0 {
            didSet(oldValue) {
                guard self.numberOfLines != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(numberOfLines: self.numberOfLines)
                self.setNeedForceLayout()
            }
        }
        public var color: UI.Color? = .clear {
            didSet(oldValue) {
                guard self.color != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(color: self.color)
            }
        }
        public var border: UI.Border = .none {
            didSet(oldValue) {
                guard self.border != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(border: self.border)
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet(oldValue) {
                guard self.cornerRadius != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(cornerRadius: self.cornerRadius)
                self._view.updateShadowPath()
            }
        }
        public var shadow: UI.Shadow? = nil {
            didSet(oldValue) {
                guard self.shadow != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(shadow: self.shadow)
                self._view.updateShadowPath()
            }
        }
        public var alpha: Float = 1 {
            didSet(oldValue) {
                guard self.alpha != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(alpha: self.alpha)
            }
        }
        public var onAppear: ((UI.View.AttributedText) -> Void)?
        public var onDisappear: ((UI.View.AttributedText) -> Void)?
        public var onVisible: ((UI.View.AttributedText) -> Void)?
        public var onVisibility: ((UI.View.AttributedText) -> Void)?
        public var onInvisible: ((UI.View.AttributedText) -> Void)?
        public var onTap: ((UI.View.AttributedText, [NSAttributedString.Key: Any]?) -> Void)?
        
        private var _reuse: UI.Reuse.Item< Reusable >
        private var _view: Reusable.Content {
            return self._reuse.content()
        }
        private var _cacheAvailable: SizeFloat?
        private var _cacheSize: SizeFloat?
        
        public init(
            _ text: NSAttributedString
        ) {
            self.text = text
            self._reuse = UI.Reuse.Item()
            self._reuse.configure(owner: self)
        }
        
        public convenience init(
            text: NSAttributedString,
            configure: (UI.View.AttributedText) -> Void
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
                sizeWithWidth: { return self.text.size(available: Size(width: $0, height: .infinity)) },
                sizeWithHeight: { return self.text.size(available: Size(width: .infinity, height: $0)) },
                size: { return self.text.size(available: available) }
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

public extension UI.View.AttributedText {
    
    @inlinable
    @discardableResult
    func text(_ value: NSAttributedString) -> Self {
        self.text = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: UI.Text.Alignment?) -> Self {
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

public extension UI.View.AttributedText {
    
    @discardableResult
    func onAppear(_ value: ((UI.View.AttributedText) -> Void)?) -> Self {
        self.onAppear = value
        return self
    }
    
    @discardableResult
    func onDisappear(_ value: ((UI.View.AttributedText) -> Void)?) -> Self {
        self.onDisappear = value
        return self
    }
    
    @discardableResult
    func onVisible(_ value: ((UI.View.AttributedText) -> Void)?) -> Self {
        self.onVisible = value
        return self
    }
    
    @discardableResult
    func onVisibility(_ value: ((UI.View.AttributedText) -> Void)?) -> Self {
        self.onVisibility = value
        return self
    }
    
    @discardableResult
    func onInvisible(_ value: ((UI.View.AttributedText) -> Void)?) -> Self {
        self.onInvisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onTap(_ value: ((UI.View.AttributedText, [NSAttributedString.Key: Any]?) -> Void)?) -> Self {
        self.onTap = value
        return self
    }
    
}

extension UI.View.AttributedText : KKAttributedTextViewDelegate {
    
    func shouldTap(_ view: KKAttributedTextView) -> Bool {
        return self.onTap != nil
    }
    
    func tap(_ view: KKAttributedTextView, attributes: [NSAttributedString.Key: Any]?) {
        self.onTap?(self, attributes)
    }
    
}
