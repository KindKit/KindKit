//
//  KindKit
//

public protocol FromNumberTrait {
	
    init< Input : BinaryInteger >(_ input: Input)
    
    init< Input : BinaryFloatingPoint >(_ input: Input)
    
}
