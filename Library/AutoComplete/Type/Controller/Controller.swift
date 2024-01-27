//
//  KindKit
//

public protocol Controller : AnyObject {
    
    func begin()
    func update(_ input: String) -> Match?
    func end()

}
