//
//  KindKit
//

import Foundation

public extension FlowBuilder {

    struct Head< Head : IFlowOperator > {
        
        public let head: Head
        
        public init(
            head: Head
        ) {
            self.head = head
        }
        
    }
    
}

public extension FlowBuilder.Head {
    
    func pipeline() -> FlowPipeline< Head.Input, Head.Output > {
        return FlowPipeline(head: self.head, tail: self.head)
    }
    
}
