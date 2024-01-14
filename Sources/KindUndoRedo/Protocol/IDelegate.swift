//
//  KindKit
//

public protocol IDelegate : AnyObject {
    
    func create(context: IPermanentContext)
    func update(context: IPermanentContext)
    func delete(context: IPermanentContext)
    
}
