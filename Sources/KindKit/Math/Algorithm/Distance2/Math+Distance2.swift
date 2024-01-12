//
//  KindKit
//

import Foundation

extension Math {
    
    public enum Distance2 {
        
        public struct PointIntoLine : Equatable {
            
            public let closest: Percent
            public let point: Point
            
        }
        
        public struct PointIntoPolylineEdge : Equatable {
            
            public let edge: Polyline2.EdgeIndex
            public let closest: Percent
            public let point: Point
            
        }
        
    }
    
}
