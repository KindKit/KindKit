//
//  KindKit
//

import KindLocalize

public extension Volume {
    
    struct Unit : DerivedUnit {
        
        public typealias Finder = KindLocalize.BundleFinder
        public typealias Value = Length.Unit.Value
        
        public static var finder: Finder {
            return .init(
                bundle: .module,
                table: .custom("Volume")
            )
        }
        
        public static var `super`: Length.Unit {
            return .base
        }
        
        public static var base: Unit {
            return.meter
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

extension Volume.Unit : Hashable {
}

extension Volume.Unit : Equatable {
}

extension Volume.Unit : Sendable {
}

// MARK: Metric units

public extension Volume.Unit {
    
    /// The quettameter unit of volume.
    static var quettameter: Self {
        return .init(super: .quettameter)
    }
    
    /// The ronnameter unit of volume.
    static var ronnameter: Self {
        return .init(super: .ronnameter)
    }
    
    /// The yottameter unit of volume.
    static var yottameter: Self {
        return .init(super: .yottameter)
    }
    
    /// The zettameter unit of volume.
    static var zettameter: Self {
        return .init(super: .zettameter)
    }
    
    /// The exameter unit of volume.
    static var exameter: Self {
        return .init(super: .exameter)
    }
    
    /// The petameter unit of volume.
    static var petameter: Self {
        return .init(super: .petameter)
    }
    
    /// The terameter unit of volume.
    static var terameter: Self {
        return .init(super: .terameter)
    }
    
    /// The gigameter unit of volume.
    static var gigameter: Self {
        return .init(super: .gigameter)
    }
    
    /// The megameter unit of volume.
    static var megameter: Self {
        return .init(super: .megameter)
    }
    
    /// The kilometer unit of volume.
    static var kilometer: Self {
        return .init(super: .kilometer)
    }
    
    /// The hectometer unit of volume.
    static var hectometer: Self {
        return .init(super: .hectometer)
    }
    
    /// The decameter unit of volume.
    static var decameter: Self {
        return .init(super: .decameter)
    }
    
    /// The meter unit of volume.
    static var meter: Self {
        return .init(super: .meter)
    }
    
    /// The decimeter unit of volume.
    static var decimeter: Self {
        return .init(super: .decimeter)
    }
    
    /// The centimeter unit of volume.
    static var centimeter: Self {
        return .init(super: .centimeter)
    }
    
    /// The millimeter unit of volume.
    static var millimeter: Self {
        return .init(super: .millimeter)
    }
    
    /// The micrometer unit of volume.
    static var micrometer: Self {
        return .init(super: .micrometer)
    }
    
    /// The nanometer unit of volume.
    static var nanometer: Self {
        return .init(super: .nanometer)
    }
    
    /// The picometer unit of volume.
    static var picometer: Self {
        return .init(super: .picometer)
    }
    
    /// The femtometer unit of volume.
    static var femtometer: Self {
        return .init(super: .femtometer)
    }
    
    /// The attometer unit of volume.
    static var attometer: Self {
        return .init(super: .attometer)
    }
    
    /// The zeptometer unit of volume.
    static var zeptometer: Self {
        return .init(super: .zeptometer)
    }
    
    /// The yoctometer unit of volume.
    static var yoctometer: Self {
        return .init(super: .yoctometer)
    }
    
    /// The rontometer unit of volume.
    static var rontometer: Self {
        return .init(super: .rontometer)
    }
    
    /// The quectometer unit of volume.
    static var quectometer: Self {
        return .init(super: .quectometer)
    }
    
}

// MARK: Imperial well-known units

public extension Volume.Unit {
    
    /// The inch unit of volume.
    static var inch: Self {
        return .init(super: .inch)
    }
    
    /// The foot unit of volume.
    static var foot: Self {
        return .init(super: .foot)
    }
    
    /// The yard unit of volume.
    static var yard: Self {
        return .init(super: .yard)
    }
    
    /// The mile unit of volume.
    static var mile: Self {
        return .init(super: .mile)
    }
    
}
