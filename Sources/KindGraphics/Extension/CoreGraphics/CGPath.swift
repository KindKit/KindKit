//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics
import KindMath

public extension CGPath {
    
    static func kk_roundRect(
        rect: Rect,
        border: Double,
        corner: CornerRadius
    ) -> CGPath {
        return Self.kk_roundRect(
            rect: rect.inset(.init(
                horizontal: border / 2,
                vertical: border / 2
            )),
            corner: corner
        )
    }
    
    static func kk_roundRect(
        rect: Rect,
        corner: CornerRadius
    ) -> CGPath {
        var tl: Double
        var tr: Double
        var bl: Double
        var br: Double
        switch corner {
        case .none:
            tl = 0
            tr = 0
            bl = 0
            br = 0
        case .manual(let radius, let edges):
            if edges.contains(.topLeft) == true {
                tl = radius
            } else {
                tl = 0
            }
            if edges.contains(.topRight) == true {
                tr = radius
            } else {
                tr = 0
            }
            if edges.contains(.bottomLeft) == true {
                bl = radius
            } else {
                bl = 0
            }
            if edges.contains(.bottomRight) == true {
                br = radius
            } else {
                br = 0
            }
        case .auto(let percent, let edges):
            if rect.width > 0 && rect.height > 0 {
                let mr = ceil(min(rect.width - 1, rect.height - 1)) * percent.value
                if edges.contains(.topLeft) == true {
                    tl = mr
                } else {
                    tl = 0
                }
                if edges.contains(.topRight) == true {
                    tr = mr
                } else {
                    tr = 0
                }
                if edges.contains(.bottomLeft) == true {
                    bl = mr
                } else {
                    bl = 0
                }
                if edges.contains(.bottomRight) == true {
                    br = mr
                } else {
                    br = 0
                }
            } else {
                tl = 0
                tr = 0
                bl = 0
                br = 0
            }
        }
        if tl + tr > rect.width {
            let hw = rect.width / 2
            tl = min(tl, hw)
            tr = min(tr, hw)
        }
        if tl + bl > rect.height {
            let hh = rect.height / 2
            tl = min(tl, hh)
            bl = min(bl, hh)
        }
        if bl + br > rect.width {
            let hw = rect.width / 2
            bl = min(bl, hw)
            br = min(br, hw)
        }
        if tr + br > rect.height {
            let hh = rect.height / 2
            tr = min(tr, hh)
            br = min(br, hh)
        }
        return Self.kk_roundRect(
            rect: rect,
            tl: tl,
            tr: tr,
            bl: bl,
            br: br
        )
    }
    
}

#endif
