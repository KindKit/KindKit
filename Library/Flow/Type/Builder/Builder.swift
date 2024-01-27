//
//  KindKit
//

public struct Builder< Success, Failure : Swift.Error > : BuilderTrait {
    
    public typealias Head = NoneOperator< Result< Success, Failure > >
    public typealias Tail = Head
    
    let head = Head()
    
    public init() {
    }
    
    public func build() -> Flow< Head.Input, Tail.Output > {
        return Flow(head: self.head, tail: self.head)
    }
    
    public func append< Operator : KindFlow.Operator >(_ `operator`: @autoclosure () -> Operator) -> BuilderChain< Head, Operator > {
        let next = `operator`()
        self.head.connect(next: next)
        return .init(head: self.head, tail: next)
    }
    
}
