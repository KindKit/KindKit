//
//  KindKit
//

#if os(iOS)

import Foundation

public extension UI.View.Web {
    
    enum State {
        
        case empty
        case loading
        case loaded(Error?)
        
    }
    
}

extension UI.View.Web.State : Equatable {
    
    public static func == (lhs: UI.View.Web.State, rhs: UI.View.Web.State) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty): return true
        case (.loading, .loading): return true
        case (.loaded, .loaded): return true
        default: return false
        }
    }
    
}

#endif
