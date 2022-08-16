//
//  KindKitFlow
//

import Foundation

public extension Builder {

    struct Head< Head : IFlowOperator > {
        
        public let head: Head
        
        public init(
            head: Head
        ) {
            self.head = head
        }
        
    }
    
}

public extension Builder.Head {
    
    func pipeline() -> Pipeline< Head.Input, Head.Output > {
        return Pipeline(head: self.head, tail: self.head)
    }
    
}
