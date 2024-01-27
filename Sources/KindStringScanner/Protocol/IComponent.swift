//
//  KindKit
//

public protocol IComponent {
    
    func scan(_ scanner: Scanner, in context: Pattern.Context) throws
    
}
