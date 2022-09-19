//
//  KindKit
//

import Foundation

public extension FlowBuilder {

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

public extension FlowBuilder.Chain {
    
    func pipeline() -> FlowPipeline< Head.Input, Tail.Output > {
        return FlowPipeline(head: self.head, tail: self.tail)
    }
    
}
