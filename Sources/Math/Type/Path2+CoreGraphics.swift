//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension Path2 {
    
    @inlinable
    var cgPath: CGPath {
        let cgPath = CGMutablePath()
        for element in self.elements {
            switch element {
            case .move(let to): cgPath.move(to: to.cgPoint)
            case .line(let to): cgPath.addLine(to: to.cgPoint)
            case .quad(let to, let control): cgPath.addQuadCurve(to: to.cgPoint, control: control.cgPoint)
            case .cubic(let to, let control1, let control2): cgPath.addCurve(to: to.cgPoint, control1: control1.cgPoint, control2: control2.cgPoint)
            case .close: cgPath.closeSubpath()
            }
        }
        return cgPath
    }
    
    init(_ cgPath: CGPath) {
        self.elements = cgPath.elements.map({
            switch $0.type {
            case .moveToPoint: return .move(to: Point($0.points[0]))
            case .addLineToPoint: return .line(to: Point($0.points[0]))
            case .addQuadCurveToPoint: return .quad(to: Point($0.points[1]), control: Point($0.points[0]))
            case .addCurveToPoint: return .cubic(to: Point($0.points[2]), control1: Point($0.points[1]), control2: Point($0.points[0]))
            case .closeSubpath: return .close
            @unknown default: fatalError("unhandled case of CGPathElement")
            }
        })
    }
    
}

#endif
