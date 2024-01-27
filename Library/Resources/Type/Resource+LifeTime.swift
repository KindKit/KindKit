//
//  KindKit
//

public extension Resource {
    
    enum LifeTime {
        
        case temporary
        
        case due(Due)
        
        case unuse(Unuse)
        
    }
    
}
