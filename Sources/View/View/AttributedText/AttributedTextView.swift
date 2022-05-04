//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

protocol AttributedTextViewDelegate : AnyObject {
    
    func shouldTap() -> Bool
    func tap(attributes: [NSAttributedString.Key: Any]?)
    
}

public class AttributedTextView : IAttributedTextView {
    
    public private(set) unowned var layout: ILayout?
    public unowned var item: LayoutItem?
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
    public private(set) var isVisible: Bool
    public var isHidden: Bool {
        didSet(oldValue) {
            guard self.isHidden != oldValue else { return }
            self.setNeedForceLayout()
        }
    }
    public var width: DynamicSizeBehaviour {
        didSet(oldValue) {
            guard self.width != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._cacheAvailable = nil
            self._cacheSize = nil
            self.setNeedForceLayout()
        }
    }
    public var height: DynamicSizeBehaviour {
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
    public var alignment: TextAlignment? {
        didSet(oldValue) {
            guard self.alignment != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(alignment: self.alignment)
            self.setNeedLayout()
        }
    }
    public var lineBreak: TextLineBreak {
        didSet(oldValue) {
            guard self.lineBreak != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(lineBreak: self.lineBreak)
            self.setNeedForceLayout()
        }
    }
    public var numberOfLines: UInt {
        didSet(oldValue) {
            guard self.numberOfLines != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(numberOfLines: self.numberOfLines)
            self.setNeedForceLayout()
        }
    }
    public var color: Color? {
        didSet(oldValue) {
            guard self.color != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(color: self.color)
        }
    }
    public var border: ViewBorder {
        didSet(oldValue) {
            guard self.border != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(border: self.border)
        }
    }
    public var cornerRadius: ViewCornerRadius {
        didSet(oldValue) {
            guard self.cornerRadius != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(cornerRadius: self.cornerRadius)
            self._view.updateShadowPath()
        }
    }
    public var shadow: ViewShadow? {
        didSet(oldValue) {
            guard self.shadow != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(shadow: self.shadow)
            self._view.updateShadowPath()
        }
    }
    public var alpha: Float {
        didSet(oldValue) {
            guard self.alpha != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(alpha: self.alpha)
        }
    }
    
    private var _reuse: ReuseItem< Reusable >
    private var _view: Reusable.Content {
        return self._reuse.content()
    }
    private var _onAppear: (() -> Void)?
    private var _onDisappear: (() -> Void)?
    private var _onVisible: (() -> Void)?
    private var _onVisibility: (() -> Void)?
    private var _onInvisible: (() -> Void)?
    private var _onTap: ((_ attributes: [NSAttributedString.Key: Any]?) -> Void)?
    private var _cacheAvailable: SizeFloat?
    private var _cacheSize: SizeFloat?
    
    public init(
        reuseBehaviour: ReuseItemBehaviour = .unloadWhenDisappear,
        reuseName: String? = nil,
        width: DynamicSizeBehaviour = .fit,
        height: DynamicSizeBehaviour = .fit,
        text: NSAttributedString,
        alignment: TextAlignment? = nil,
        lineBreak: TextLineBreak = .wordWrapping,
        numberOfLines: UInt = 0,
        color: Color? = Color(r: 0.0, g: 0.0, b: 0.0, a: 0.0),
        border: ViewBorder = .none,
        cornerRadius: ViewCornerRadius = .none,
        shadow: ViewShadow? = nil,
        alpha: Float = 1,
        isHidden: Bool = false
    ) {
        self.isVisible = false
        self.width = width
        self.height = height
        self.text = text
        self.alignment = alignment
        self.lineBreak = lineBreak
        self.numberOfLines = numberOfLines
        self.color = color
        self.border = border
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.alpha = alpha
        self.isHidden = isHidden
        self._reuse = ReuseItem(behaviour: reuseBehaviour, name: reuseName)
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
        let size = DynamicSizeBehaviour.apply(
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
    
    public func appear(to layout: ILayout) {
        self.layout = layout
        self._onAppear?()
    }
    
    public func disappear() {
        self._reuse.disappear()
        self.layout = nil
        self._onDisappear?()
    }
    
    public func visible() {
        self.isVisible = true
        self._onVisible?()
    }
    
    public func visibility() {
        self._onVisibility?()
    }
    
    public func invisible() {
        self.isVisible = false
        self._onInvisible?()
    }
    
    @discardableResult
    public func width(_ value: DynamicSizeBehaviour) -> Self {
        self.width = value
        return self
    }
    
    @discardableResult
    public func height(_ value: DynamicSizeBehaviour) -> Self {
        self.height = value
        return self
    }
    
    @discardableResult
    public func text(_ value: NSAttributedString) -> Self {
        self.text = value
        return self
    }
    
    @discardableResult
    public func alignment(_ value: TextAlignment?) -> Self {
        self.alignment = value
        return self
    }
    
    @discardableResult
    public func lineBreak(_ value: TextLineBreak) -> Self {
        self.lineBreak = value
        return self
    }
    
    @discardableResult
    public func numberOfLines(_ value: UInt) -> Self {
        self.numberOfLines = value
        return self
    }
    
    @discardableResult
    public func color(_ value: Color?) -> Self {
        self.color = value
        return self
    }
    
    @discardableResult
    public func border(_ value: ViewBorder) -> Self {
        self.border = value
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ value: ViewCornerRadius) -> Self {
        self.cornerRadius = value
        return self
    }
    
    @discardableResult
    public func shadow(_ value: ViewShadow?) -> Self {
        self.shadow = value
        return self
    }
    
    @discardableResult
    public func alpha(_ value: Float) -> Self {
        self.alpha = value
        return self
    }
    
    @discardableResult
    public func hidden(_ value: Bool) -> Self {
        self.isHidden = value
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
    
    @discardableResult
    public func onVisible(_ value: (() -> Void)?) -> Self {
        self._onVisible = value
        return self
    }
    
    @discardableResult
    public func onVisibility(_ value: (() -> Void)?) -> Self {
        self._onVisibility = value
        return self
    }
    
    @discardableResult
    public func onInvisible(_ value: (() -> Void)?) -> Self {
        self._onInvisible = value
        return self
    }
    
    @discardableResult
    public func onTap(_ value: ((_ attributes: [NSAttributedString.Key: Any]?) -> Void)?) -> Self {
        self._onTap = value
        return self
    }

}

extension AttributedTextView : AttributedTextViewDelegate {
    
    func shouldTap() -> Bool {
        return self._onTap != nil
    }
    
    func tap(attributes: [NSAttributedString.Key: Any]?) {
        self._onTap?(attributes)
    }
    
}
