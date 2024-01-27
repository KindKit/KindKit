//
//  KindKit
//

public protocol FormatterTrait : Equatable {
    
    associatedtype Input
    associatedtype Output

    func format(_ input: Input) -> Output

}

public extension FormatterTrait where Self : AnyObject {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs
    }
    
}
