//
//  KindKit
//

public protocol ApplierTrait : Equatable {
    
    associatedtype Input
    associatedtype Target
    
    func apply(_ input: Input, _ target: Target)
    
}
