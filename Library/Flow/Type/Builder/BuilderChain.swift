//
//  KindKit
//

public struct BuilderChain< Head : Operator, Tail : Operator > : BuilderTrait {
    
    public let head: Head
    public let tail: Tail
    
    public func build() -> Flow< Head.Input, Tail.Output > {
        return Flow(head: self.head, tail: self.tail)
    }
    
    public func append< Operator : KindFlow.Operator >(_ `operator`: @autoclosure () -> Operator) -> BuilderChain< Head, Operator > {
        let next = `operator`()
        self.tail.connect(next: next)
        return .init(head: self.head, tail: next)
    }
    
}
