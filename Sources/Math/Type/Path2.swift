//
//  KindKitMath
//

import Foundation
import CoreGraphics

public typealias Path2Float = Path2< Float >
public typealias Path2Double = Path2< Double >

public struct Path2< Value : IScalar & Hashable > : Hashable {
    
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
        case move(to: Point< Value >)
        case line(to: Point< Value >)
        case quad(to: Point< Value >, control: Point< Value >)
        case cubic(to: Point< Value >, control1: Point< Value >, control2: Point< Value >)
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
    mutating func move(to point: Point< Value >) {
        self.elements.append(.move(to: point))
    }
    
    @inlinable
    mutating func line(to point: Point< Value >) {
        self.elements.append(.line(to: point))
    }
    
    @inlinable
    mutating func quad(to point: Point< Value >, control: Point< Value >) {
        self.elements.append(.quad(to: point, control: control))
    }
    
    @inlinable
    mutating func quad(to point: Point< Value >, control1: Point< Value >, control2: Point< Value >) {
        self.elements.append(.cubic(to: point, control1: control1, control2: control2))
    }
    
    @inlinable
    mutating func close() {
        self.elements.append(.close)
    }
    
}
