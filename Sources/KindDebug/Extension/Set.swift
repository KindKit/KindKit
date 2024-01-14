//
//  KindKit
//

extension Set : IEntity {
    
    public func debugInfo() -> Info {
        return .sequence(self.map({ .cast($0) }))
    }

}
