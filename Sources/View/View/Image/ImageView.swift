//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public final class ImageView : IImageView {
    
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
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var height: DynamicSizeBehaviour {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var aspectRatio: Float? {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var image: Image {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(image: self.image)
            self.setNeedForceLayout()
        }
    }
    public var mode: ImageViewMode {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(mode: self.mode)
            self.setNeedForceLayout()
        }
    }
    public var color: Color? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(color: self.color)
        }
    }
    public var tintColor: Color? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(tintColor: self.tintColor)
        }
    }
    public var cornerRadius: ViewCornerRadius {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(cornerRadius: self.cornerRadius)
        }
    }
    public var border: ViewBorder {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(border: self.border)
        }
    }
    public var shadow: ViewShadow? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(shadow: self.shadow)
        }
    }
    public var alpha: Float {
        didSet {
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
    
    public init(
        reuseBehaviour: ReuseItemBehaviour = .unloadWhenDisappear,
        reuseName: String? = nil,
        width: DynamicSizeBehaviour = .fit,
        height: DynamicSizeBehaviour = .fit,
        aspectRatio: Float? = nil,
        image: Image,
        mode: ImageViewMode = .aspectFit,
        color: Color? = nil,
        tintColor: Color? = nil,
        border: ViewBorder = .none,
        cornerRadius: ViewCornerRadius = .none,
        shadow: ViewShadow? = nil,
        alpha: Float = 1,
        isHidden: Bool = false
    ) {
        self.isVisible = false
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
        self.image = image
        self.mode = mode
        self.color = color
        self.tintColor = tintColor
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
        return DynamicSizeBehaviour.apply(
            available: available,
            width: self.width,
            height: self.height,
            sizeWithWidth: {
                switch self.mode {
                case .origin:
                    if let aspectRatio = self.aspectRatio {
                        return SizeFloat(width: $0, height: $0 / aspectRatio)
                    }
                    return image.size
                case .aspectFit, .aspectFill:
                    let aspectRatio = self.aspectRatio ?? self.image.size.aspectRatio
                    return SizeFloat(width: $0, height: $0 / aspectRatio)
                }
            },
            sizeWithHeight: {
                switch self.mode {
                case .origin:
                    if let aspectRatio = self.aspectRatio {
                        return SizeFloat(width: $0 * aspectRatio, height: $0)
                    }
                    return image.size
                case .aspectFit, .aspectFill:
                    let aspectRatio = self.aspectRatio ?? self.image.size.aspectRatio
                    return SizeFloat(width: $0 * aspectRatio, height: $0)
                }
            },
            size: {
                switch self.mode {
                case .origin:
                    if let aspectRatio = self.aspectRatio {
                        if available.width.isInfinite == true && available.height.isInfinite == false {
                            return SizeFloat(
                                width: available.height * aspectRatio,
                                height: available.height
                            )
                        } else if available.width.isInfinite == false && available.height.isInfinite == true {
                            return SizeFloat(
                                width: available.width,
                                height: available.width / aspectRatio
                            )
                        }
                    }
                    return self.image.size
                case .aspectFit, .aspectFill:
                    if available.isInfinite == true {
                        return self.image.size
                    } else if available.width.isInfinite == true {
                        let aspectRatio = self.image.size.aspectRatio
                        return SizeFloat(
                            width: available.height * aspectRatio,
                            height: available.height
                        )
                    } else if available.height.isInfinite == true {
                        let aspectRatio = self.image.size.aspectRatio
                        return SizeFloat(
                            width: available.width,
                            height: available.width / aspectRatio
                        )
                    }
                    return self.image.size.aspectFit(available)
                }
            }
        )
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
    public func aspectRatio(_ value: Float?) -> Self {
        self.aspectRatio = value
        return self
    }
    
    @discardableResult
    public func image(_ value: Image) -> Self {
        self.image = value
        return self
    }
    
    @discardableResult
    public func mode(_ value: ImageViewMode) -> Self {
        self.mode = value
        return self
    }
    
    @discardableResult
    public func color(_ value: Color?) -> Self {
        self.color = value
        return self
    }
    
    @discardableResult
    public func tintColor(_ value: Color?) -> Self {
        self.tintColor = value
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

}
