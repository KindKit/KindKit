//
//  KindKit
//

import KindString

public extension Query {
    
    struct Limit {
        
        let limit: Count
        let offset: Count?
        
    }
    
}

extension Query.Limit : IExpressable {
    
    public var query: String {
        return .kk_build({
            LettersComponent("LIMIT")
            SpaceComponent()
            LettersComponent(self.limit)
            if let offset = self.offset {
                LettersComponent(" OFFSET ")
                LettersComponent(offset)
            }
        })
    }
    
}
