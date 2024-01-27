//
//  KindKit
//

public protocol Holder : AnyObject {
    
    func insert(_ item: any Item, at index: Int)
    func remove(_ item: any Item)
    
}
