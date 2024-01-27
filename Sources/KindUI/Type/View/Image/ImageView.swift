//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindMonadicMacro

@KindMonadic
public final class ImageView : IView, IViewDynamicSizeable, IViewTintColorable, IViewColorable, IViewAlphable {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var handle: NativeView {
        return self._layout.view
    }
    
    public var isLoaded: Bool {
        return self._layout.isLoaded
    }
    
    public var size: DynamicSize = .fit {
        didSet {
            guard self.size != oldValue else { return }
            self.updateLayout(force: true)
        }
    }
    
    public var tintColor: Color? {
        didSet {
            guard self.tintColor != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(tintColor: self.tintColor)
            }
        }
    }
    
    public var color: Color? {
        didSet {
            guard self.color != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(color: self.color)
            }
        }
    }
    
    public var alpha: Double = 1 {
        didSet {
            guard self.alpha != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(alpha: self.alpha)
            }
        }
    }
    
    @KindMonadicProperty
    public var image: Image? {
        didSet {
            guard self.image != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(image: self.image)
            }
            self.updateLayout(force: true)
        }
    }
    
    @KindMonadicProperty
    public var mode: Mode = .aspectFit {
        didSet {
            guard self.mode != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(mode: self.mode)
            }
            self.updateLayout(force: true)
        }
    }
    
    public var onAppear: Signal< Void, Bool > {
        return self._layout.onAppear
    }
    
    public var onDisappear: Signal< Void, Void > {
        return self._layout.onDisappear
    }
    
    private var _layout: ReuseLayoutItem< Reusable >!
    
    public init() {
        self._layout = .init(self)
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        guard let image = self.image else { return .zero }
        return self.size.resolve(
            by: request,
            withWidth: { width, maximum in
                let aspectRatio = image.size.aspectRatio
                let height = width / aspectRatio
                if height > maximum {
                    return .init(width: maximum * aspectRatio, height: maximum)
                }
                return .init(width: width, height: height)
            },
            withHeight: { height, maximum in
                let aspectRatio = image.size.aspectRatio
                let width = height / aspectRatio
                if width > maximum {
                    return .init(width: maximum, height: maximum / aspectRatio)
                }
                return .init(width: width, height: height)
            },
            withSize: { maximum in
                switch self.mode {
                case .origin:
                    return image.size
                case .aspectFit, .aspectFill:
                    let aspectRatio = image.size.aspectRatio
                    if maximum.width > maximum.height {
                        return .init(width: maximum.height * aspectRatio, height: maximum.height)
                    } else {
                        return .init(width: maximum.width, height: maximum.width / aspectRatio)
                    }
                }
            }
        )
    }

}
