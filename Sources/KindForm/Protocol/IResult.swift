//
//  KindKit
//

import Foundation

public protocol IResult {
    
    var id: Id { get }
    
    func find(by id: Id) -> IResult?
    
}

public extension IResult {
    
    @inlinable
    func contains(id: Id) -> Bool {
        return self.find(by: id) != nil
    }
    
}
 
public extension Array where Element == IResult {
    
    @inlinable
    func first(id: Id) -> Element? {
        for form in self {
            if let form = form.find(by: id) {
                return form
            }
        }
        return nil
    }
    
    @inlinable
    func contains(id: Id) -> Bool {
        for form in self {
            if form.contains(id: id) == true {
                return true
            }
        }
        return false
    }
    
}
