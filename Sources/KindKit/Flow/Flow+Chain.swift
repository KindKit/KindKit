//
//  KindKit
//

import Foundation

public extension Flow {

    struct Chain< Head : IFlowOperator, Tail : IFlowOperator > : IFlowBuilder {
        
        public let head: Head
        public let tail: Tail
        
        public func pipeline() -> Flow.Pipeline< Head.Input, Tail.Output > {
            return Flow.Pipeline(head: self.head, tail: self.tail)
        }
        
        public func append< Operator : IFlowOperator >(_ `operator`: @autoclosure () -> Operator) -> Flow.Chain< Head, Operator > {
            let next = `operator`()
            self.tail.subscribe(next: next)
            return .init(head: self.head, tail: next)
        }
        
    }
    
}
