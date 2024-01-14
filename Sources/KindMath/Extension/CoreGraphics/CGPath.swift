//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension CGPath {
    
    static func kk_roundRect(
        rect: Rect,
        tl: Double,
        tr: Double,
        bl: Double,
        br: Double
    ) -> CGPath {
        let k = 0.552284749831
        let vtl = tl * k
        let vtr = tr * k
        let vbl = bl * k
        let vbr = br * k
        let itl = tl - vtl
        let itr = tr - vtr
        let ibl = bl - vbl
        let ibr = br - vbr
        let topLeft = rect.topLeft
        let topRight = rect.topRight
        let bottomLeft = rect.bottomLeft
        let bottomRight = rect.bottomRight
        let path = CGMutablePath()
        if tl > .leastNonzeroMagnitude {
            path.move(to: .init(x: topLeft.x + tl, y: topLeft.y))
        } else {
            path.move(to: .init(x: topLeft.x, y: topLeft.y))
        }
        if tr > .leastNonzeroMagnitude {
            path.addLine(to: .init(x: topRight.x - tr, y: topRight.y))
            path.addCurve(
                to: .init(x: topRight.x, y: topRight.y + tr),
                control1: .init(x: topRight.x - itr, y: topRight.y),
                control2: .init(x: topRight.x, y: topRight.y + itr)
            )
        } else {
            path.addLine(to: .init(x: topRight.x, y: topRight.y))
        }
        if br > .leastNonzeroMagnitude {
            path.addLine(to: .init(x: bottomRight.x, y: bottomRight.y - br))
            path.addCurve(
                to: .init(x: bottomRight.x - br, y: bottomRight.y),
                control1: .init(x: bottomRight.x, y: bottomRight.y - ibr),
                control2: .init(x: bottomRight.x - ibr, y: bottomRight.y)
            )
        } else {
            path.addLine(to: .init(x: bottomRight.x, y: bottomRight.y))
        }
        if bl > .leastNonzeroMagnitude {
            path.addLine(to: .init(x: bottomLeft.x + bl, y: bottomLeft.y))
            path.addCurve(
                to: .init(x: bottomLeft.x, y: bottomLeft.y - bl),
                control1: .init(x: bottomLeft.x + ibl, y: bottomLeft.y),
                control2: .init(x: bottomLeft.x, y: bottomLeft.y - ibl)
            )
        } else {
            path.addLine(to: .init(x: bottomLeft.x, y: bottomLeft.y))
        }
        if tl > .leastNonzeroMagnitude {
            path.addLine(to: .init(x: topLeft.x, y: topLeft.y + tl))
            path.addCurve(
                to: .init(x: topLeft.x + tl, y: topLeft.y),
                control1: .init(x: topLeft.x, y: topLeft.y + itl),
                control2: .init(x: topLeft.x + itl, y: topLeft.y)
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
