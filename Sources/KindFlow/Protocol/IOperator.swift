//
//  KindKit
//

public protocol IOperator : IPipe {
    
    associatedtype Input : IResult
    associatedtype Output : IResult
    
    func subscribe(next: IPipe)

    func receive(value: Input.Success)
    func receive(error: Input.Failure)
    
}

public extension IOperator {
    
    func send(value: Any) {
        self.receive(value: value as! Input.Success)
    }
    
    func send(error: Any) {
        self.receive(error: error as! Input.Failure)
    }
    
}
