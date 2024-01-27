//
//  KindKit
//

#if os(iOS)

import KindGraphics

extension SegmentedView {
    
    public enum Item : Equatable {
        
        case string(String)
        case image(Image)
        
    }
    
}

public extension SegmentedView.Item {
    
    static func string< Localized : ILocalized >(_ string: Localized) -> Self {
        return .string(string.localized)
    }
    
}

#endif
