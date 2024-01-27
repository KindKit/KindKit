//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout

public final class ImageView : IView, IViewSupportDynamicSize, IViewSupportImage, IViewSupportTintColor, IViewSupportColor, IViewSupportAlpha {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var size: DynamicSize = .fit {
        didSet {
            guard self.size != oldValue else { return }
            self.updateLayout(force: true)
        }
    }
    
    public var image: Image {
        didSet {
            guard self.image != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(image: self.image)
            }
            self.updateLayout(force: true)
        }
    }
    
    public var mode: ImageMode = .aspectFit {
        didSet {
            guard self.mode != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(mode: self.mode)
            }
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
    
    public var color: Color = .clear {
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
    
    private var _layout: ReuseLayoutItem< Reusable >!
    
    public init(_ image: Image) {
        self.image = image
        self._layout = .init(self)
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self.size.resolve(
            by: request,
            withWidth: { width, maximum in
                let aspectRatio = self.image.size.aspectRatio
                let height = width / aspectRatio
                if height > maximum {
                    return .init(width: maximum * aspectRatio, height: maximum)
                }
                return .init(width: width, height: height)
            },
            withHeight: { height, maximum in
                let aspectRatio = self.image.size.aspectRatio
                let width = height / aspectRatio
                if width > maximum {
                    return .init(width: maximum, height: maximum / aspectRatio)
                }
                return .init(width: width, height: height)
            },
            withSize: { maximum in
                switch self.mode {
                case .origin:
                    return self.image.size
                case .aspectFit, .aspectFill:
                    let aspectRatio = self.image.size.aspectRatio
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

extension ImageView : IViewSupportStyleSheet {
    
    public func apply(_ styleSheet: ImageStyleSheet) -> Self {
        if let image = styleSheet.image {
            self.image = image
        }
        if let mode = styleSheet.mode {
            self.mode = mode
        }
        if let tintColor = styleSheet.tintColor {
            self.tintColor = tintColor
        }
        if let color = styleSheet.color {
            self.color = color
        }
        if let alpha = styleSheet.alpha {
            self.alpha = alpha
        }
        return self
    }
    
}
