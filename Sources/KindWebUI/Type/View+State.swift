//
//  KindKit
//

#if os(iOS)

public extension View {
    
    enum State {
        
        case empty
        case loading
        case loaded(Swift.Error?)
        
    }
    
}

extension View.State : Equatable {
    
    public static func == (lhs: View.State, rhs: View.State) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty): return true
        case (.loading, .loading): return true
        case (.loaded, .loaded): return true
        default: return false
        }
    }
    
}

#endif
