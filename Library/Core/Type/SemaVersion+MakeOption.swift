//
//  KindKit
//

public extension SemaVersion {
    
    struct MakeOptions : OptionSet {
        
        public typealias RawValue = UInt
        
        public var rawValue: RawValue
        
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
    }
    
}

extension SemaVersion.MakeOptions : Hashable {
}

extension SemaVersion.MakeOptions : Equatable {
}

extension SemaVersion.MakeOptions : Sendable {
}

public extension SemaVersion.MakeOptions {
    
    @inlinable
    static var major: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var minor: Self {
        return .init(rawValue: 1 << 1)
    }
    
    @inlinable
    static var patch: Self {
        return .init(rawValue: 1 << 2)
    }
    
    @inlinable
    static var preRelease: Self {
        return .init(rawValue: 1 << 3)
    }
    
    @inlinable
    static var build: Self {
        return .init(rawValue: 1 << 4)
    }
    
    @inlinable
    static var majorMinor: Self {
        return [ .major, .minor ]
    }
    
    @inlinable
    static var majorMinorPatch: Self {
        return [ .major, .minor, .patch ]
    }
    
    @inlinable
    static var full: Self {
        return [ .major, .minor, .patch, .preRelease, .build ]
    }
    
}
