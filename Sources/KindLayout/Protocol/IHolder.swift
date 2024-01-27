//
//  KindKit
//

public protocol IHolder : AnyObject {
    
    func insert(_ item: IItem, at index: Int)
    func remove(_ item: IItem)
    
}
