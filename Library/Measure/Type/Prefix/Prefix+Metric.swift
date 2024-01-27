//
//  KindKit
//

import KindNumeric

extension Prefix {
    
    public enum Metric : String {
        
        case quetta
        case ronna
        case yotta
        case zetta
        case exa
        case peta
        case tera
        case giga
        case mega
        case kilo
        case hecto
        case deca
        case none = ""
        case deci
        case centi
        case milli
        case micro
        case nano
        case pico
        case femto
        case atto
        case zepto
        case yocto
        case ronto
        case quecto
        
    }
    
}

public extension Prefix.Metric {
    
    var coefficient: Double {
        switch self {
        case .quetta: return .nonillion
        case .ronna: return .octillion
        case .yotta: return .septillion
        case .zetta: return .sextillion
        case .exa: return .quintillion
        case .peta: return .quadrillion
        case .tera: return .trillion
        case .giga: return .billion
        case .mega: return .million
        case .kilo: return .thousand
        case .hecto: return .hundred
        case .deca: return .ten
        case .none: return .one
        case .deci: return .tenth
        case .centi: return .hundredth
        case .milli: return .thousandth
        case .micro: return .millionth
        case .nano: return .billionth
        case .pico: return .trillionth
        case .femto: return .quadrillionth
        case .atto: return .quintillionth
        case .zepto: return .sextillionth
        case .yocto: return .septillionth
        case .ronto: return .octillionth
        case .quecto: return .nonillionth
        }
    }
    
    var constant: Double {
        return 0
    }
    
}
