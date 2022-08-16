//
//  KindKitFlow
//

import Foundation

public extension Builder {

    struct Chain< Head : IFlowOperator, Tail : IFlowOperator > {
        
        public let head: Head
        public let tail: Tail
        
        public init(
            head: Head,
            tail: Tail
        ) {
            self.head = head
            self.tail = tail
        }
        
    }
    
}

public extension Builder.Chain {
    
    func pipeline() -> Pipeline< Head.Input, Tail.Output > {
        return Pipeline(head: self.head, tail: self.tail)
    }
    
}
