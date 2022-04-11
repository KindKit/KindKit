//
//  KindKitMath
//

import Foundation
import CoreGraphics

public typealias Path2Float = Path2< Float >
public typealias Path2Double = Path2< Double >

public struct Path2< ValueType: IScalar & Hashable > : Hashable {
    
    public typealias PointType = Point< ValueType >
    
    public var elements: [Element]
    
    @inlinable
    public init(
        elements: [Element]
    ) {
        self.elements = elements
    }
    
}

public extension Path2 {
    
    enum Element : Hashable {
        case move(to: Path2.PointType)
        case line(to: Path2.PointType)
        case quad(to: Path2.PointType, control: Path2.PointType)
        case cubic(to: Path2.PointType, control1: Path2.PointType, control2: Path2.PointType)
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
    
}

public extension Path2 {
    
    @inlinable
    mutating func append(_ other: Self) {
        self.elements.append(contentsOf: other.elements)
    }
    
    @inlinable
    mutating func move(to point: Path2.PointType) {
        self.elements.append(.move(to: point))
    }
    
    @inlinable
    mutating func line(to point: Path2.PointType) {
        self.elements.append(.line(to: point))
    }
    
    @inlinable
    mutating func quad(to point: Path2.PointType, control: Path2.PointType) {
        self.elements.append(.quad(to: point, control: control))
    }
    
    @inlinable
    mutating func quad(to point: Path2.PointType, control1: Path2.PointType, control2: Path2.PointType) {
        self.elements.append(.cubic(to: point, control1: control1, control2: control2))
    }
    
    @inlinable
    mutating func close() {
        self.elements.append(.close)
    }
    
}
