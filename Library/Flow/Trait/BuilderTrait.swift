//
//  KindKit
//

public protocol BuilderTrait {
    
    associatedtype Head : Operator
    associatedtype Tail : Operator
    
    func build() -> Flow< Head.Input, Tail.Output >
    
    func append< Operator : KindFlow.Operator >(_ `operator`: @autoclosure () -> Operator) -> BuilderChain< Head, Operator >
    
}
