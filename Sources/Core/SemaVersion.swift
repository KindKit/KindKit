//
//  KindKit
//

import Foundation

public struct SemaVersion : Codable, Equatable, Hashable {
    
    public var major: Int
    public var minor: Int
    public var patch: Int
    public var preRelease: String
    public var build: String

    public init(_ major: Int, _ minor: Int, _ patch: Int, _ preRelease: String = "", _ build: String = "") {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.preRelease = preRelease
        self.build = build
    }
    
}

public extension SemaVersion {
    
    var isStable: Bool {
        return self.preRelease.isEmpty == true && self.build.isEmpty == true
    }
    
    var isPreRelease: Bool {
        return self.isStable == false
    }
    
    var isMajorRelease: Bool {
        return self.isStable == true && (self.major > 0 && self.minor == 0 && self.patch == 0)
    }
    
    var isMinorRelease: Bool {
        return self.isStable == true && (self.minor > 0 && self.patch == 0)
    }
    
    var isPatchRelease: Bool {
        return self.isStable == true && self.patch > 0
    }
    
    func make(options: MakeOptions = [ .major, .minor, .patch, .preRelease, .build ]) -> String {
        var result = ""
        if options.contains(.major) == true || options.contains(.minor) == true || options.contains(.patch) == true {
            var components: [String] = []
            if options.contains(.major) == true {
                components.append("\(self.major)")
            }
            if options.contains(.minor) == true {
                components.append("\(self.minor)")
            }
            if options.contains(.patch) == true {
                components.append("\(self.patch)")
            }
            result = components.joined(separator: ".")
        }
        if self.preRelease.isEmpty == false && options.contains(.preRelease) == true {
            if result.isEmpty == false {
                result.append("-\(self.preRelease)")
            } else {
                result.append(self.preRelease)
            }
        }
        if self.build.isEmpty == false && options.contains(.build) == true {
            if result.isEmpty == false {
                result.append("+\(self.build)")
            } else {
                result.append(self.build)
            }
        }
        return result
    }
    
}

public extension SemaVersion {
    
    struct MakeOptions : OptionSet {
        
        public typealias RawValue = UInt
        
        public var rawValue: RawValue
        
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
        public static var major = MakeOptions(rawValue: 1 << 0)
        public static var minor = MakeOptions(rawValue: 1 << 1)
        public static var patch = MakeOptions(rawValue: 1 << 2)
        public static var preRelease = MakeOptions(rawValue: 1 << 3)
        public static var build = MakeOptions(rawValue: 1 << 4)
        
    }
    
}

extension SemaVersion : LosslessStringConvertible {
    
    public init?(_ string: String) {
        guard let version = Self._parse(string) else { return nil }
        self = version
    }

    public var description: String {
        return self.make()
    }
    
}

extension SemaVersion : Comparable {
    
    public static func < (lhs: SemaVersion, rhs: SemaVersion) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        if lhs.patch != rhs.patch { return lhs.patch < rhs.patch }
        if lhs.preRelease != rhs.preRelease {
            if lhs.isStable { return false }
            if rhs.isStable { return true }
            return lhs.preRelease < rhs.preRelease
        }
        return lhs.build < rhs.build
    }
    
}

private extension SemaVersion {

    static func _parse(_ string: String) -> SemaVersion? {
        let pattern = #"""
        ^
        v?
        (?<major>[0-9]\d*)
        \.
        (?<minor>[0-9]\d*)
        (?:
          \.
          (?<patch>[0-9]\d*)
        )?
        (?:-
          (?<prerelease>
            (?:[0-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)
            (?:\.
              (?:[0-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)
            )
          *)
        )?
        (?:\+
          (?<buildmetadata>[0-9a-zA-Z-]+
            (?:\.[0-9a-zA-Z-]+)
          *)
        )?
        $
        """#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [ .allowCommentsAndWhitespace ]) else { return nil }
        guard let match = regex.firstMatch(in: string, options: [], range: NSRange(string.startIndex..., in: string)) else { return nil }
        let groups: [String] = (1...regex.numberOfCaptureGroups).map {
            if let r = Range(match.range(at: $0), in: string) {
                return String(string[r])
            }
            return ""
        }
        guard groups.count == regex.numberOfCaptureGroups else { return nil }
        guard let major = Int(groups[0]), let minor = Int(groups[1]) else { return nil }
        return SemaVersion(major, minor, Int(groups[2]) ?? 0, groups[3], groups[4])
    }
    
}
