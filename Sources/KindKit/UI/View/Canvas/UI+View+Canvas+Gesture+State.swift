//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

extension UI.View.Canvas.Gesture {

    public enum State {
        
        case begin
        case change
        case end
        
    }
    
}

#endif
