//
//  KindKit
//

public struct Chain< Head : IOperator, Tail : IOperator > : IBuilder {
    
    public let head: Head
    public let tail: Tail
    
    public func pipeline() -> Pipeline< Head.Input, Tail.Output > {
        return Pipeline(head: self.head, tail: self.tail)
    }
    
    public func append< Operator : IOperator >(_ `operator`: @autoclosure () -> Operator) -> Chain< Head, Operator > {
        let next = `operator`()
        self.tail.subscribe(next: next)
        return .init(head: self.head, tail: next)
    }
    
}
