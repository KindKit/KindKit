//
//  KindKit
//

import Foundation

public extension Flow {
    
    struct Builder< Success, Failure : Swift.Error > : IFlowBuilder {
        
        public typealias Head = Flow.Operator.None< Result< Success, Failure > >
        public typealias Tail = Head
        
        public let head: Head
        
        public init() {
            self.head = Head()
        }
        
        public func pipeline() -> Flow.Pipeline< Head.Input, Tail.Output > {
            return Flow.Pipeline(head: self.head, tail: self.head)
        }
        
        public func append< Operator : IFlowOperator >(_ `operator`: @autoclosure () -> Operator) -> Flow.Chain< Head, Operator > {
            let next = `operator`()
            self.head.subscribe(next: next)
            return .init(head: self.head, tail: next)
        }
        
    }
    
}
