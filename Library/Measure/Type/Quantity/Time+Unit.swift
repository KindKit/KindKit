//
//  KindKit
//

import KindLocalize

extension Time {
    
    public struct Unit : KindMeasure.Unit {
        
        public typealias Finder = KindLocalize.BundleFinder
        public typealias Value = Double
        
        public static var finder: Finder {
            return .init(
                bundle: .module,
                table: .custom("Time")
            )
        }
        
        public static var base: Unit {
            return .second
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
                name: "\(prefix.rawValue)second"
            )
        }
        
    }
    
}

extension Time.Unit : Hashable {
}

extension Time.Unit : Equatable {
}

extension Time.Unit : Sendable {
}

// MARK: Metric units

public extension Time.Unit {
    
    /// The quettasecond unit of time.
    static var quettasecond: Self {
        return .init(prefix: .quetta)
    }
    
    /// The ronnasecond unit of time.
    static var ronnasecond: Self {
        return .init(prefix: .ronna)
    }
    
    /// The yottasecond unit of time.
    static var yottasecond: Self {
        return .init(prefix: .yotta)
    }
    
    /// The zettasecond unit of time.
    static var zettasecond: Self {
        return .init(prefix: .zetta)
    }
    
    /// The exasecond unit of time.
    static var exasecond: Self {
        return .init(prefix: .exa)
    }
    
    /// The petasecond unit of time.
    static var petasecond: Self {
        return .init(prefix: .peta)
    }
    
    /// The terasecond unit of time.
    static var terasecond: Self {
        return .init(prefix: .tera)
    }
    
    /// The gigasecond unit of time.
    static var gigasecond: Self {
        return .init(prefix: .giga)
    }
    
    /// The megasecond unit of time.
    static var megasecond: Self {
        return .init(prefix: .yotta)
    }
    
    /// The kilosecond unit of time.
    static var kilosecond: Self {
        return .init(prefix: .kilo)
    }
    
    /// The hectosecond unit of time.
    static var hectosecond: Self {
        return .init(prefix: .hecto)
    }
    
    /// The decasecond unit of time.
    static var decasecond: Self {
        return .init(prefix: .deca)
    }
    
    /// The second unit of time.
    static var second: Self {
        return .init(prefix: .none)
    }
    
    /// The decisecond unit of time.
    static var decisecond: Self {
        return .init(prefix: .deci)
    }
    
    /// The centisecond unit of time.
    static var centisecond: Self {
        return .init(prefix: .centi)
    }
    
    /// The millisecond unit of time.
    static var millisecond: Self {
        return .init(prefix: .milli)
    }
    
    /// The microsecond unit of time.
    static var microsecond: Self {
        return .init(prefix: .micro)
    }
    
    /// The nanosecond unit of time.
    static var nanosecond: Self {
        return .init(prefix: .nano)
    }
    
    /// The picosecond unit of time.
    static var picosecond: Self {
        return .init(prefix: .pico)
    }
    
    /// The femtosecond unit of time.
    static var femtosecond: Self {
        return .init(prefix: .femto)
    }
    
    /// The attosecond unit of time.
    static var attosecond: Self {
        return .init(prefix: .atto)
    }
    
    /// The zeptosecond unit of time.
    static var zeptosecond: Self {
        return .init(prefix: .zepto)
    }
    
    /// The yoctosecond unit of time.
    static var yoctosecond: Self {
        return .init(prefix: .yocto)
    }
    
    /// The rontosecond unit of time.
    static var rontosecond: Self {
        return .init(prefix: .ronto)
    }
    
    /// The quectosecond unit of time.
    static var quectosecond: Self {
        return .init(prefix: .quecto)
    }
    
}

// MARK: Specific units

public extension Time.Unit {
    
    /// The minute unit of time.
    static var minute: Self {
        return .init(coefficient: 60, name: "minute")
    }
    
    /// The hour unit of time.
    static var hour: Self {
        return .init(coefficient: 60 * 60, name: "hour")
    }
    
    /// The day unit of time.
    static var day: Self {
        return .init(coefficient: 60 * 60 * 24, name: "day")
    }
    
    /// The week unit of time.
    static var week: Self {
        return .init(coefficient: 60 * 60 * 24 * 7, name: "week")
    }
    
}
