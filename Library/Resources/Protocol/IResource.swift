//
//  KindKit
//

import Foundation

public protocol IResource : AnyObject {
    
    associatedtype Content
    
    static var category: Resource.Category { get }
    
    var id: Resource.Id { get }
    
    var content: Content { get }
    
    var createdAt: Date { get }
    
    var lastUsedAt: Date { get }
    
    var lifetime: Resource.LifeTime { get }
    
}
