//
//  KindKit
//

import Foundation

public struct Path2 : Hashable {
    
    public var elements: [Element]
    
    public init(
        elements: [Element]
    ) {
        self.elements = elements
    }
    
}

public extension Path2 {
    
    enum Element : Hashable {
        
        case move(to: Point)
        case line(to: Point)
        case quad(to: Point, control: Point)
        case cubic(to: Point, control1: Point, control2: Point)
        case close
        
    }
    
}

public extension Path2 {
    
    var isNewContour: Bool {
        guard let element = self.elements.last else { return true }
        switch element {
        case .close: return true
        default: return false
        }
    }
    
    var bbox: AlignedBox2 {
        guard self.elements.count > 0 else {
            return .zero
        }
        var bbox: AlignedBox2
        var last: Point
        switch self.elements[0] {
        case .move(let to):
            bbox = .init(lower: to, upper: to)
            last = to
        case .line(let to):
            bbox = .init(point1: .zero, point2: to)
            last = to
        case .quad(let to, let control):
            let curve = QuadCurve2(start: .zero, control: control, end: to)
            bbox = curve.bbox
            last = to
        case .cubic(let to, let control1, let control2):
            let curve = CubicCurve2(start: .zero, control1: control1, control2: control2, end: to)
            bbox = curve.bbox
            last = to
        case .close:
            bbox = .zero
            last = .zero
        }
        for element in self.elements[1..<self.elements.count] {
            switch element {
            case .move(let to):
                bbox = bbox.union(.init(point1: last, point2: to))
                last = to
            case .line(let to):
                bbox = bbox.union(.init(point1: last, point2: to))
                last = to
            case .quad(let to, let control):
                let curve = QuadCurve2(start: last, control: control, end: to)
                bbox = bbox.union(curve.bbox)
                last = to
            case .cubic(let to, let control1, let control2):
                let curve = CubicCurve2(start: last, control1: control1, control2: control2, end: to)
                bbox = bbox.union(curve.bbox)
                last = to
            case .close:
                last = .zero
            }
        }
        return bbox
    }
    
}

public extension Path2 {
    
    @inlinable
    mutating func append(_ other: Self) {
        self.elements.append(contentsOf: other.elements)
    }
    
    @inlinable
    mutating func move(to point: Point) {
        self.elements.append(.move(to: point))
    }
    
    @inlinable
    mutating func line(to point: Point) {
        self.elements.append(.line(to: point))
    }
    
    @inlinable
    mutating func quad(to point: Point, control: Point) {
        self.elements.append(.quad(to: point, control: control))
    }
    
    @inlinable
    mutating func quad(to point: Point, control1: Point, control2: Point) {
        self.elements.append(.cubic(to: point, control1: control1, control2: control2))
    }
    
    @inlinable
    mutating func close() {
        self.elements.append(.close)
    }
    
}

public extension Path2 {
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix3) -> Self {
        return .init(elements: lhs.elements.map({
            switch $0 {
            case .move(to: let to):
                return .move(
                    to: to * rhs
                )
            case .line(let to):
                return .line(
                    to: to * rhs
                )
            case .quad(let to, let control):
                return .quad(
                    to: to * rhs,
                    control: control * rhs
                )
            case .cubic(let to, let control1, let control2):
                return .cubic(
                    to: to * rhs,
                    control1: control1 * rhs,
                    control2: control2 * rhs
                )
            case .close:
                return .close
            }
        }))
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Matrix3) {
        lhs = lhs * rhs
    }
    
}

extension Path2 : IMapable {
}
