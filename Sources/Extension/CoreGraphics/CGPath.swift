//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension CGPath {
    
    static func kk_roundRect(
        rect: Rect,
        border: Double,
        corner: UI.CornerRadius
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
        corner: UI.CornerRadius
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
    
    static func kk_roundRect(
        rect: Rect,
        tl: Double,
        tr: Double,
        bl: Double,
        br: Double
    ) -> CGPath {
        let path = CGMutablePath()
        let topLeft = rect.topLeft
        let topRight = rect.topRight
        let bottomLeft = rect.bottomLeft
        let bottomRight = rect.bottomRight
        if tl > .leastNonzeroMagnitude {
            path.move(to: .init(x: topLeft.x + tl, y: topLeft.y))
        } else {
            path.move(to: .init(x: topLeft.x, y: topLeft.y))
        }
        if tr > .leastNonzeroMagnitude {
            path.addLine(to: .init(x: topRight.x - tr, y: topRight.y))
            path.addQuadCurve(
                to: .init(x: topRight.x, y: topRight.y + tr),
                control: .init(x: topRight.x, y: topRight.y)
            )
        } else {
            path.addLine(to: .init(x: topRight.x, y: topRight.y))
        }
        if br > .leastNonzeroMagnitude {
            path.addLine(to: .init(x: bottomRight.x, y: bottomRight.y - br))
            path.addQuadCurve(
                to: .init(x: bottomRight.x - br, y: bottomRight.y),
                control: .init(x: bottomRight.x, y: bottomRight.y)
            )
        } else {
            path.addLine(to: .init(x: bottomRight.x, y: bottomRight.y))
        }
        if bl > .leastNonzeroMagnitude {
            path.addLine(to: .init(x: bottomLeft.x + bl, y: bottomLeft.y))
            path.addQuadCurve(
                to: .init(x: bottomLeft.x, y: bottomLeft.y - bl),
                control: .init(x: bottomLeft.x, y: bottomLeft.y)
            )
        } else {
            path.addLine(to: .init(x: bottomLeft.x, y: bottomLeft.y))
        }
        if tl > .leastNonzeroMagnitude {
            path.addLine(to: .init(x: topLeft.x, y: topLeft.y + tl))
            path.addQuadCurve(
                to: .init(x: topLeft.x + tl, y: topLeft.y),
                control: .init(x: topLeft.x, y: topLeft.y)
            )
        } else {
            path.addLine(to: .init(x: topLeft.x, y: topLeft.y))
        }
        return path
    }
    
}

public extension CGPath {
    
    @inlinable
    var kk_elements: [CGPathElement] {
        var elements: [CGPathElement] = []
        self.kk_forEach({ element in
            elements.append(element)
        })
        return elements
    }
    
}

public extension CGPath {
    
    typealias EachClosure = @convention(block) (CGPathElement) -> Void
    
    func kk_forEach(_ body: @escaping EachClosure) {
        let callback: CGPathApplierFunction = { (info, element) in
            let body = unsafeBitCast(info, to: EachClosure.self)
            body(element.pointee)
        }
        self.apply(info: unsafeBitCast(body, to: UnsafeMutableRawPointer.self), function: callback)
    }
    
}

#endif
