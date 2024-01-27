//
//  KindKit
//

import KindLocalize

public extension Angle {
    
    struct Unit : KindMeasure.Unit {
        
        public typealias Finder = KindLocalize.BundleFinder
        public typealias Value = Double
        
        public static var finder: Finder {
            return .init(
                bundle: .module,
                table: .custom("Angle")
            )
        }
        
        @inlinable
        public static var base: Unit {
            return .turn
        }
        
        public let constant: Value
        
        public let coefficient: Value
        
        public let name: String
        
        fileprivate init(constant: Value = 0, coefficient: Value, name: String) {
            self.constant = constant
            self.coefficient = coefficient
            self.name = name
        }
        
    }
    
}

extension Angle.Unit : Hashable {
}

extension Angle.Unit : Equatable {
}

extension Angle.Unit : Sendable {
}

public extension Angle.Unit {
    
    static var turn: Self {
        return .init(coefficient: 1, name: "turn")
    }
    
    static var degree: Self {
        return .init(coefficient: 1 / 360, name: "degree")
    }
    
    static var radian: Self {
        return .init(coefficient: 1 / (.pi * 2), name: "radian")
    }
    
}
