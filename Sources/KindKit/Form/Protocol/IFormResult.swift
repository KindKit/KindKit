//
//  KindKit
//

import Foundation

public protocol IFormResult {
    
    var id: Form.Id { get }
    
    func find(by id: Form.Id) -> IFormResult?
    
}

public extension IFormResult {
    
    @inlinable
    func contains(id: Form.Id) -> Bool {
        return self.find(by: id) == nil
    }
    
}
 
public extension Array where Element == IFormResult {
    
    @inlinable
    func first(id: Form.Id) -> Element? {
        for form in self {
            if let form = form.find(by: id) {
                return form
            }
        }
        return nil
    }
    
    @inlinable
    func contains(id: Form.Id) -> Bool {
        for form in self {
            if form.contains(id: id) == true {
                return true
            }
        }
        return false
    }
    
}
