//
//  KindKit
//

public protocol Accumulator : AnyObject {
    
    associatedtype Part
    associatedtype Result
    
    func append(input: String)
    func append(part: Part)
    
    func result() -> Result
    
}
