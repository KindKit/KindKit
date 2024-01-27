//
//  KindKit
//

import KindStringScanner

public enum Specifier : Equatable {

    case ieee_1003(IEEE_1003)
    
}

extension Specifier {
    
    init?(_ match: KindStringScanner.Pattern.Output) {
        guard let raw = Pattern(match) else { return nil }
        self.init(raw)
    }
    
    init?(_ pattern: Pattern) {
        switch pattern {
        case .ieee_1003(let pattern):
            guard let specifier = IEEE_1003(pattern) else { return nil }
            self = .ieee_1003(specifier)
        }
    }
    
}

public extension Specifier {
    
    init?(_ string: String) {
        if let specifier = IEEE_1003(string) {
            self = .ieee_1003(specifier)
        } else {
            return nil
        }
    }
    
    var string: String {
        switch self {
        case .ieee_1003(let specifier): return specifier.string
        }
    }
    
    var placeholder: String? {
        switch self {
        case .ieee_1003(let specifier): return specifier.placeholder
        }
    }
    
    func format< ValueType : BinaryInteger >(_ value: ValueType) -> String? {
        switch self {
        case .ieee_1003(let specifier): return specifier.format(value)
        }
    }
    
    func format< ValueType : BinaryFloatingPoint >(_ value: ValueType) -> String? {
        switch self {
        case .ieee_1003(let specifier): return specifier.format(value)
        }
    }
    
    func format(_ value: String) -> String? {
        switch self {
        case .ieee_1003(let specifier): return specifier.format(value)
        }
    }
    
}
