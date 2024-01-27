//
//  KindKit
//

public typealias RealEnumCodableTrait = RealEnumDecodeTrait & RealEnumEncodeTrait

public protocol RealEnumDecodeTrait {
    
    associatedtype RealValue
    
    var realValue: RealValue { get }
    
}

public protocol RealEnumEncodeTrait {
    
    associatedtype RealValue
    
    init(realValue: RealValue)
    
}
