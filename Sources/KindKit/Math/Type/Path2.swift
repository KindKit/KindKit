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

extension Path2 : IMapable {
}
