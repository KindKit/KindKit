//
//  KindKit
//

public extension Result {
    
    struct Sequence : IResult {
        
        public let id: Id
        public let value: [IResult]
        
        public init(id: Id, value: [IResult]) {
            self.id = id
            self.value = value
        }
        
        public func find(by id: Id) -> IResult? {
            if self.id == id {
                return self
            }
            for value in self.value {
                if let value = value.find(by: id) {
                    return value
                }
            }
            return nil
        }
        
    }
    
}

public extension Result {
    
    static func value(id: Id, value: [IResult]) -> Sequence {
        return .init(id: id, value: value)
    }
    
}
