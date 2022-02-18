//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public class AnimatedImageView : IAnimatedImageView {
    
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
    public var width: DimensionBehaviour? {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var height: DimensionBehaviour? {
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
    public var images: [Image] {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(images: self.images)
            self.setNeedForceLayout()
        }
    }
    public var duration: TimeInterval {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(duration: self.duration)
        }
    }
    public var `repeat`: AnimatedImageViewRepeat {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(repeat: self.repeat)
        }
    }
    public var mode: AnimatedImageViewMode {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(mode: self.mode)
            self.setNeedForceLayout()
        }
    }
    public var isAnimating: Bool {
        guard self.isLoaded == true else { return false }
        return self._view.isAnimating
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
        width: DimensionBehaviour? = nil,
        height: DimensionBehaviour? = nil,
        aspectRatio: Float? = nil,
        images: [Image],
        duration: TimeInterval,
        `repeat`: AnimatedImageViewRepeat,
        mode: AnimatedImageViewMode = .aspectFit,
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
        self.images = images
        self.duration = duration
        self.repeat = `repeat`
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
    
    @discardableResult
    public func start() -> Self {
        self._view.startAnimating()
        return self
    }

    @discardableResult
    public func stop() -> Self {
        self._view.stopAnimating()
        return self
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        guard self.isHidden == false else { return .zero }
        guard let image = self.images.first else { return .zero }
        if let width = self.width, let height = self.height {
            return available.apply(width: width, height: height, aspectRatio: self.aspectRatio)
        } else if let widthBehaviour = self.width, let width = widthBehaviour.value(available.width) {
            switch self.mode {
            case .origin:
                if let aspectRatio = self.aspectRatio {
                    return SizeFloat(
                        width: width,
                        height: width / aspectRatio
                    )
                }
                return image.size
            case .aspectFit, .aspectFill:
                let aspectRatio = self.aspectRatio ?? image.size.aspectRatio
                return SizeFloat(
                    width: width,
                    height: width / aspectRatio
                )
            }
        } else if let heightBehaviour = self.height, let height = heightBehaviour.value(available.height) {
            switch self.mode {
            case .origin:
                if let aspectRatio = self.aspectRatio {
                    return SizeFloat(
                        width: height * aspectRatio,
                        height: height
                    )
                }
                return image.size
            case .aspectFit, .aspectFill:
                let aspectRatio = self.aspectRatio ?? image.size.aspectRatio
                return SizeFloat(
                    width: height * aspectRatio,
                    height: height
                )
            }
        }
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
            return image.size
        case .aspectFit, .aspectFill:
            if available.isInfinite == true {
                return image.size
            } else if available.width.isInfinite == true {
                let aspectRatio = image.size.aspectRatio
                return SizeFloat(
                    width: available.height * aspectRatio,
                    height: available.height
                )
            } else if available.height.isInfinite == true {
                let aspectRatio = image.size.aspectRatio
                return SizeFloat(
                    width: available.width,
                    height: available.width / aspectRatio
                )
            }
            return image.size.aspectFit(available)
        }
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
    public func width(_ value: DimensionBehaviour?) -> Self {
        self.width = value
        return self
    }
    
    @discardableResult
    public func height(_ value: DimensionBehaviour?) -> Self {
        self.height = value
        return self
    }
    
    @discardableResult
    public func aspectRatio(_ value: Float?) -> Self {
        self.aspectRatio = value
        return self
    }
    
    @discardableResult
    public func images(_ value: [Image]) -> Self {
        self.images = value
        return self
    }
    
    @discardableResult
    public func duration(_ value: TimeInterval) -> Self {
        self.duration = value
        return self
    }
    
    @discardableResult
    public func `repeat`(_ value: AnimatedImageViewRepeat) -> Self {
        self.repeat = value
        return self
    }
    
    @discardableResult
    public func mode(_ value: AnimatedImageViewMode) -> Self {
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
