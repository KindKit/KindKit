//
//  KindKit
//

import KindLocalize

public extension Area {
    
    struct Unit : DerivedUnit {
        
        public typealias Finder = KindLocalize.BundleFinder
        public typealias Value = Length.Unit.Value
        
        public static var finder: Finder {
            return .init(
                bundle: .module,
                table: .custom("Area")
            )
        }
        
        @inlinable
        public static var `super`: Length.Unit {
            return .base
        }
        
        @inlinable
        public static var base: Area.Unit {
            return .meter
        }
        
        public let constant: Value
        
        public let coefficient: Value
        
        public let name: String
        
        public init(`super` unit: Length.Unit) {
            self.constant = unit.constant
            self.coefficient = unit.coefficient
            self.name = unit.name
        }
        
    }
    
}

extension Area.Unit : Hashable {
}

extension Area.Unit : Equatable {
}

extension Area.Unit : Sendable {
}

// MARK: Metric units

public extension Area.Unit {
    
    /// The quettameter unit of area.
    static var quettameter: Self {
        return .init(super: .quettameter)
    }
    
    /// The ronnameter unit of area.
    static var ronnameter: Self {
        return .init(super: .ronnameter)
    }
    
    /// The yottameter unit of area.
    static var yottameter: Self {
        return .init(super: .yottameter)
    }
    
    /// The zettameter unit of area.
    static var zettameter: Self {
        return .init(super: .zettameter)
    }
    
    /// The exameter unit of area.
    static var exameter: Self {
        return .init(super: .exameter)
    }
    
    /// The petameter unit of area.
    static var petameter: Self {
        return .init(super: .petameter)
    }
    
    /// The terameter unit of area.
    static var terameter: Self {
        return .init(super: .terameter)
    }
    
    /// The gigameter unit of area.
    static var gigameter: Self {
        return .init(super: .gigameter)
    }
    
    /// The megameter unit of area.
    static var megameter: Self {
        return .init(super: .megameter)
    }
    
    /// The kilometer unit of area.
    static var kilometer: Self {
        return .init(super: .kilometer)
    }
    
    /// The hectometer unit of area.
    static var hectometer: Self {
        return .init(super: .hectometer)
    }
    
    /// The decameter unit of area.
    static var decameter: Self {
        return .init(super: .decameter)
    }
    
    /// The meter unit of area.
    static var meter: Self {
        return .init(super: .meter)
    }
    
    /// The decimeter unit of area.
    static var decimeter: Self {
        return .init(super: .decimeter)
    }
    
    /// The centimeter unit of area.
    static var centimeter: Self {
        return .init(super: .centimeter)
    }
    
    /// The millimeter unit of area.
    static var millimeter: Self {
        return .init(super: .millimeter)
    }
    
    /// The micrometer unit of area.
    static var micrometer: Self {
        return .init(super: .micrometer)
    }
    
    /// The nanometer unit of area.
    static var nanometer: Self {
        return .init(super: .nanometer)
    }
    
    /// The picometer unit of area.
    static var picometer: Self {
        return .init(super: .picometer)
    }
    
    /// The femtometer unit of area.
    static var femtometer: Self {
        return .init(super: .femtometer)
    }
    
    /// The attometer unit of area.
    static var attometer: Self {
        return .init(super: .attometer)
    }
    
    /// The zeptometer unit of area.
    static var zeptometer: Self {
        return .init(super: .zeptometer)
    }
    
    /// The yoctometer unit of area.
    static var yoctometer: Self {
        return .init(super: .yoctometer)
    }
    
    /// The rontometer unit of area.
    static var rontometer: Self {
        return .init(super: .rontometer)
    }
    
    /// The quectometer unit of area.
    static var quectometer: Self {
        return .init(super: .quectometer)
    }
    
}

// MARK: Imperial well-known units

public extension Area.Unit {
    
    /// The inch unit of area.
    static var inch: Self {
        return .init(super: .inch)
    }
    
    /// The foot unit of area.
    static var foot: Self {
        return .init(super: .foot)
    }
    
    /// The yard unit of area.
    static var yard: Self {
        return .init(super: .yard)
    }
    
    /// The mile unit of area.
    static var mile: Self {
        return .init(super: .mile)
    }
    
}
