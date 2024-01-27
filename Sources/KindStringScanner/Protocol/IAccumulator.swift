//
//  KindKit
//

public protocol IAccumulator : AnyObject {
    
    associatedtype PartType
    associatedtype ResultType
    
    func append(input: String)
    func append(part: PartType)
    
    func result() -> ResultType
    
}
