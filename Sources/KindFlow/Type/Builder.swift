//
//  KindKit
//

public struct Builder< Success, Failure : Swift.Error > : IBuilder {
    
    public typealias Head = Operator.None< Result< Success, Failure > >
    public typealias Tail = Head
    
    public let head: Head
    
    public init() {
        self.head = Head()
    }
    
    public func pipeline() -> Pipeline< Head.Input, Tail.Output > {
        return Pipeline(head: self.head, tail: self.head)
    }
    
    public func append< Operator : IOperator >(_ `operator`: @autoclosure () -> Operator) -> Chain< Head, Operator > {
        let next = `operator`()
        self.head.subscribe(next: next)
        return .init(head: self.head, tail: next)
    }
    
}
