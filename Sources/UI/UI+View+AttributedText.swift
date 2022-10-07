//
//  KindKit
//

import Foundation

protocol KKAttributedTextViewDelegate : AnyObject {
    
    func shouldTap(_ view: KKAttributedTextView) -> Bool
    func tap(_ view: KKAttributedTextView, attributes: [NSAttributedString.Key: Any]?)
    
}

public extension UI.View {

    final class AttributedText : IUIViewReusable, IUIView, IUIViewDynamicSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
            didSet {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
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
        public var width: UI.Size.Dynamic = .fit {
            didSet {
                guard self.width != oldValue else { return }
                self._cacheAvailable = nil
                self._cacheSize = nil
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Dynamic = .fit {
            didSet {
                guard self.height != oldValue else { return }
                self._cacheAvailable = nil
                self._cacheSize = nil
                self.setNeedForceLayout()
            }
        }
        public var color: UI.Color? = .clear {
            didSet {
                guard self.color != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(color: self.color)
                }
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.cornerRadius != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(cornerRadius: self.cornerRadius)
                }
            }
        }
        public var border: UI.Border = .none {
            didSet {
                guard self.border != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(border: self.border)
                }
            }
        }
        public var shadow: UI.Shadow? = nil {
            didSet {
                guard self.shadow != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(shadow: self.shadow)
                }
            }
        }
        public var alpha: Float = 1 {
            didSet {
                guard self.alpha != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(alpha: self.alpha)
                }
            }
        }
        public var text: NSAttributedString {
            didSet {
                guard self.text != oldValue else { return }
                self._cacheAvailable = nil
                self._cacheSize = nil
                if self.isLoaded == true {
                    self._view.update(text: self.text, alignment: self.alignment)
                }
                self.setNeedForceLayout()
            }
        }
        public var alignment: UI.Text.Alignment? = nil {
            didSet {
                guard self.alignment != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(alignment: self.alignment)
                }
                self.setNeedLayout()
            }
        }
        public var lineBreak: UI.Text.LineBreak = .wordWrapping {
            didSet {
                guard self.lineBreak != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(lineBreak: self.lineBreak)
                }
                self.setNeedForceLayout()
            }
        }
        public var numberOfLines: UInt = 0 {
            didSet {
                guard self.numberOfLines != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(numberOfLines: self.numberOfLines)
                }
                self.setNeedForceLayout()
            }
        }
        public let onAppear: Signal.Empty< Void > = .init()
        public let onDisappear: Signal.Empty< Void > = .init()
        public let onVisible: Signal.Empty< Void > = .init()
        public let onVisibility: Signal.Empty< Void > = .init()
        public let onInvisible: Signal.Empty< Void > = .init()
        public let onTap: Signal.Args< Void, [NSAttributedString.Key: Any]? > = .init()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { return self._reuse.content }
        private var _cacheAvailable: SizeFloat?
        private var _cacheSize: SizeFloat?
        
        public init(
            _ text: NSAttributedString
        ) {
            self.text = text
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
                sizeWithWidth: { return self.text.kk_size(available: Size(width: $0, height: .infinity)) },
                sizeWithHeight: { return self.text.kk_size(available: Size(width: .infinity, height: $0)) },
                size: { return self.text.kk_size(available: available) }
            )
            self._cacheAvailable = available
            self._cacheSize = size
            return size
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

extension UI.View.AttributedText : KKAttributedTextViewDelegate {
    
    func shouldTap(_ view: KKAttributedTextView) -> Bool {
        return self.onTap.isEmpty == false
    }
    
    func tap(_ view: KKAttributedTextView, attributes: [NSAttributedString.Key: Any]?) {
        self.onTap.emit(attributes)
    }
    
}
