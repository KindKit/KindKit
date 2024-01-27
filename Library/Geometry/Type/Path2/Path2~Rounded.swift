//
//  KindKit
//

import KindNumeric

public extension Path2 {
    
    static func round(
        rect: Rect,
        tl: Coordinate,
        tr: Coordinate,
        bl: Coordinate,
        br: Coordinate
    ) -> Self {
        var ctl = tl
        var ctr = br
        var cbl = tl
        var cbr = br
        if tl + tr > rect.width {
            let hw = rect.width.halved()
            ctl = ctl.min(hw)
            ctr = ctr.min(hw)
        }
        if ctl + cbl > rect.height {
            let hh = rect.height.halved()
            ctl = ctl.min(hh)
            cbl = cbl.min(hh)
        }
        if cbl + cbr > rect.width {
            let hw = rect.width.halved()
            cbl = cbl.min(hw)
            cbr = cbr.min(hw)
        }
        if ctr + cbr > rect.height {
            let hh = rect.height.halved()
            ctr = ctr.min(hh)
            cbr = cbr.min(hh)
        }
        let k = 0.552284749831
        let vtl = ctl * k
        let vtr = ctr * k
        let vbl = cbl * k
        let vbr = cbr * k
        let itl = ctl - vtl
        let itr = ctr - vtr
        let ibl = cbl - vbl
        let ibr = cbr - vbr
        let topLeft = rect.topLeft
        let topRight = rect.topRight
        let bottomLeft = rect.bottomLeft
        let bottomRight = rect.bottomRight
        var path = Path2(elements: [])
        if ctl.isMoreEpsilon {
            path.move(to: .init(x: topLeft.x + ctl, y: topLeft.y))
        } else {
            path.move(to: .init(x: topLeft.x, y: topLeft.y))
        }
        if ctr.isMoreEpsilon {
            path.line(to: .init(x: topRight.x - ctr, y: topRight.y))
            path.cubic(
                to: .init(x: topRight.x, y: topRight.y + ctr),
                control1: .init(x: topRight.x - itr, y: topRight.y),
                control2: .init(x: topRight.x, y: topRight.y + itr)
            )
        } else {
            path.line(to: .init(x: topRight.x, y: topRight.y))
        }
        if cbr.isMoreEpsilon {
            path.line(to: .init(x: bottomRight.x, y: bottomRight.y - cbr))
            path.cubic(
                to: .init(x: bottomRight.x - cbr, y: bottomRight.y),
                control1: .init(x: bottomRight.x, y: bottomRight.y - ibr),
                control2: .init(x: bottomRight.x - ibr, y: bottomRight.y)
            )
        } else {
            path.line(to: .init(x: bottomRight.x, y: bottomRight.y))
        }
        if cbl.isMoreEpsilon {
            path.line(to: .init(x: bottomLeft.x + cbl, y: bottomLeft.y))
            path.cubic(
                to: .init(x: bottomLeft.x, y: bottomLeft.y - cbl),
                control1: .init(x: bottomLeft.x + ibl, y: bottomLeft.y),
                control2: .init(x: bottomLeft.x, y: bottomLeft.y - ibl)
            )
        } else {
            path.line(to: .init(x: bottomLeft.x, y: bottomLeft.y))
        }
        if ctl.isMoreEpsilon {
            path.line(to: .init(x: topLeft.x, y: topLeft.y + ctl))
            path.cubic(
                to: .init(x: topLeft.x + ctl, y: topLeft.y),
                control1: .init(x: topLeft.x, y: topLeft.y + itl),
                control2: .init(x: topLeft.x + itl, y: topLeft.y)
            )
        } else {
            path.line(to: .init(x: topLeft.x, y: topLeft.y))
        }
        path.close()
        return path
    }
    
}
