//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindMonadicMacro

@Monadic
public final class ShapeView : IView, IViewSupportDynamicSize, IViewSupportColor, IViewSupportAlpha {
    
    public var layout: some ILayoutItem {
        return self._layout
    }

    public var size: DynamicSize = .fit {
        didSet {
            guard self.size != oldValue else { return }
            self.updateLayout(force: true)
        }
    }
    
    @MonadicField
    public var path: Path2? {
        didSet {
            guard self.path != oldValue else { return }
            if let path = self.path {
                self._pathBbox = path.bbox
            } else {
                self._pathBbox = nil
            }
            if self.isLoaded == true {
                self._layout.view.kk_update(path: self.path)
            }
        }
    }
    
    @MonadicField
    public var fill: Fill? {
        didSet {
            guard self.fill != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(fill: self.fill)
            }
        }
    }
    
    @MonadicField
    public var stroke: Stroke? {
        didSet {
            guard self.stroke != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(stroke: self.stroke)
            }
        }
    }
    
    @MonadicField
    public var line: Line = .init() {
        didSet {
            guard self.line != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(line: self.line)
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
    
    private var _pathBbox: AlignedBox2?
    private var _layout: ReuseLayoutItem< Reusable >!
    
    public init() {
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self.size.resolve(
            by: request,
            calculate: {
                guard let bbox = self._pathBbox else { return .zero }
                return $0.min(bbox.size)
            }
        )
    }

}

extension ShapeView : IViewSupportStyleSheet {
    
    public func apply(_ styleSheet: ShapeStyleSheet) -> Self {
        if let fill = styleSheet.fill {
            self.fill = fill
        }
        if let stroke = styleSheet.stroke {
            self.stroke = stroke
        }
        if let line = styleSheet.line {
            self.line = line
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
