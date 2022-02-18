//
//  KindKitMath
//

import Foundation
import CoreGraphics

public struct Path< ValueType: BinaryFloatingPoint > : Hashable {
    
    public typealias PointType = Point< ValueType >
    
    public var contours: [Contour]
    
    @inlinable
    public init(
        contours: [Contour] = []
    ) {
        self.contours = contours
    }
    
}

public extension Path {
    
    struct Contour : Hashable {
        
        public var origin: PointType
        public var elements: [Element]
        
    }
    
}

public extension Path.Contour {
    
    enum Element : Hashable {
        case line(to: Line)
        case quad(to: Quad)
        case cubic(to: Cubic)
    }
    
}

public extension Path.Contour.Element {
    
    struct Line : Hashable {
        
        public let point: Path.PointType
        
    }
    
    struct Quad : Hashable {
        
        public let point: Path.PointType
        public let control: Path.PointType
        
    }
    
    struct Cubic : Hashable {
        
        public let point: Path.PointType
        public let control1: Path.PointType
        public let control2: Path.PointType
        
    }
    
}
