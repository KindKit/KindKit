//
//  KindKit
//

public protocol IApplier {
    
    associatedtype InputType
    associatedtype TargetType
    
    func apply(_ input: InputType, _ target: TargetType)
    
}
