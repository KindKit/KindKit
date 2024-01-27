//
//  KindKit
//

import Foundation

public protocol IResourceHolder : AnyObject {
    
    associatedtype Resource : IResource
    
    func load() -> Resource
    
    func destroy()
    
}
