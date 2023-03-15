//
//  KindKit
//

import Foundation

public extension Form.Result {
    
    struct Sequence : IFormResult {
        
        public let id: Form.Id
        public let value: [IFormResult]
        
        public init(id: Form.Id, value: [IFormResult]) {
            self.id = id
            self.value = value
        }
        
        public func find(by id: Form.Id) -> IFormResult? {
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

public extension IFormResult where Self == Form.Result.Sequence {
    
    static func value(id: Form.Id, value: [IFormResult]) -> Self {
        return .init(id: id, value: value)
    }
    
}
