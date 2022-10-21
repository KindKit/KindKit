//
//  KindKit
//

#if os(iOS)

import Foundation

public extension UI.View.Segmented {
    
    enum Item : Equatable {
        
        case string(String)
        case image(UI.Image)
        
    }
    
}

public extension UI.View.Segmented.Item {
    
    static func string< Localized : IEnumLocalized >(_ string: Localized) -> Self {
        return .string(string.localized)
    }
    
}

#endif
