//
//  KindKit
//

import KindLocalize
import KindString

public enum Width {
    
    case symbol
    
    case abbreviation
    
    case full
    
}

extension Width {
    
    @inlinable
    var variants: [Width] {
        switch self {
        case .symbol: return [ .symbol, .abbreviation ]
        case .abbreviation: return [ .abbreviation, .symbol ]
        case .full: return [ .full, .abbreviation, .symbol ]
        }
    }
    
    @inlinable
    func key(by unit: String, in finder: any Finder) -> Key {
        switch self {
        case .symbol: return .init("\(unit)_symbol", in: finder)
        case .abbreviation: return .init("\(unit)_abbreviation", in: finder)
        case .full: return .init("\(unit)_full", in: finder)
        }
    }
    
}
