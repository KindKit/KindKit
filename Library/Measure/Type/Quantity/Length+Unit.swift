//
//  KindKit
//

import KindLocalize

public extension Length {
    
    struct Unit : KindMeasure.Unit {
        
        public typealias Finder = KindLocalize.BundleFinder
        public typealias Value = Double
        
        public static var finder: Finder {
            return .init(
                bundle: .module,
                table: .custom("Length")
            )
        }
        
        public static var base: Unit {
            return .meter
        }
        
        public let constant: Value
        
        public let coefficient: Value
        
        public let name: String
        
        fileprivate init(constant: Value = 0, coefficient: Value, name: String) {
            self.constant = constant
            self.coefficient = coefficient
            self.name = name
        }
        
        fileprivate init(prefix: Prefix.Metric) {
            self.init(
                constant: prefix.constant,
                coefficient: prefix.coefficient,
                name: "\(prefix.rawValue)meter"
            )
        }
        
    }
    
}

extension Length.Unit : Hashable {
}

extension Length.Unit : Equatable {
}

extension Length.Unit : Sendable {
}

// MARK: Metric units

public extension Length.Unit {
    
    /// The quettameter unit of length.
    static var quettameter: Self {
        return .init(prefix: .quetta)
    }
    
    /// The ronnameter unit of length.
    static var ronnameter: Self {
        return .init(prefix: .ronna)
    }
    
    /// The yottameter unit of length.
    static var yottameter: Self {
        return .init(prefix: .yotta)
    }
    
    /// The zettameter unit of length.
    static var zettameter: Self {
        return .init(prefix: .zetta)
    }
    
    /// The exameter unit of length.
    static var exameter: Self {
        return .init(prefix: .exa)
    }
    
    /// The petameter unit of length.
    static var petameter: Self {
        return .init(prefix: .peta)
    }
    
    /// The terameter unit of length.
    static var terameter: Self {
        return .init(prefix: .tera)
    }
    
    /// The gigameter unit of length.
    static var gigameter: Self {
        return .init(prefix: .giga)
    }
    
    /// The megameter unit of length.
    static var megameter: Self {
        return .init(prefix: .yotta)
    }
    
    /// The kilometer unit of length.
    static var kilometer: Self {
        return .init(prefix: .kilo)
    }
    
    /// The hectometer unit of length.
    static var hectometer: Self {
        return .init(prefix: .hecto)
    }
    
    /// The decameter unit of length.
    static var decameter: Self {
        return .init(prefix: .deca)
    }
    
    /// The meter unit of length.
    static var meter: Self {
        return .init(prefix: .none)
    }
    
    /// The decimeter unit of length.
    static var decimeter: Self {
        return .init(prefix: .deci)
    }
    
    /// The centimeter unit of length.
    static var centimeter: Self {
        return .init(prefix: .centi)
    }
    
    /// The millimeter unit of length.
    static var millimeter: Self {
        return .init(prefix: .milli)
    }
    
    /// The micrometer unit of length.
    static var micrometer: Self {
        return .init(prefix: .micro)
    }
    
    /// The nanometer unit of length.
    static var nanometer: Self {
        return .init(prefix: .nano)
    }
    
    /// The picometer unit of length.
    static var picometer: Self {
        return .init(prefix: .pico)
    }
    
    /// The femtometer unit of length.
    static var femtometer: Self {
        return .init(prefix: .femto)
    }
    
    /// The attometer unit of length.
    static var attometer: Self {
        return .init(prefix: .atto)
    }
    
    /// The zeptometer unit of length.
    static var zeptometer: Self {
        return .init(prefix: .zepto)
    }
    
    /// The yoctometer unit of length.
    static var yoctometer: Self {
        return .init(prefix: .yocto)
    }
    
    /// The rontometer unit of length.
    static var rontometer: Self {
        return .init(prefix: .ronto)
    }
    
    /// The quectometer unit of length.
    static var quectometer: Self {
        return .init(prefix: .quecto)
    }
    
}

// MARK: Imperial well-known units

public extension Length.Unit {
    
    /// The inch unit of length.
    static var inch: Self {
        return .init(coefficient: 2.54e-2, name: "inch")
    }
    
    /// The foot unit of length.
    static var foot: Self {
        return .init(coefficient: Length.Unit.inch.coefficient * 12, name: "foot")
    }
    
    /// The yard unit of length.
    static var yard: Self {
        return .init(coefficient: Length.Unit.inch.coefficient * 36, name: "yard")
    }
    
    /// The mile unit of length.
    static var mile: Self {
        return .init(coefficient: 1.609344e+3, name: "mile")
    }
    
}

// MARK: Imperial land units

public extension Length.Unit {
    
    /// The furlong unit of length.
    static var furlong: Self {
        return .init(coefficient: 2.01168e+2, name: "furlong")
    }
    
    /// The link unit of length.
    static var link: Self {
        return .init(coefficient: 2.01168, name: "link")
    }
    
    /// The rod unit of length.
    static var rod: Self {
        return .init(coefficient: Length.Unit.inch.coefficient * 198, name: "rod")
    }
    
    /// The pole unit of length.
    static var pole: Self {
        return .init(coefficient: Length.Unit.rod.coefficient, name: "pole")
    }
    
    /// The rod unit of length.
    static var perch: Self {
        return .init(coefficient: Length.Unit.rod.coefficient, name: "perch")
    }
    
}

// MARK: Imperial nautical units

public extension Length.Unit {
    
    /// The fathom unit of length.
    static var fathom: Self {
        return .init(coefficient: Length.Unit.inch.coefficient * 72, name: "fathom")
    }
    
    /// The cable unit of length.
    static var cable: Self {
        return .init(coefficient: Length.Unit.foot.coefficient * 608, name: "cable")
    }
    
    /// The nautical mile unit of length.
    static var nauticalMile: Self {
        return .init(coefficient: Length.Unit.cable.coefficient * 10, name: "nautical_mile")
    }
    
}
