//
//  KindKit
//

import Foundation

public protocol Target : AnyObject, Sendable {
    
    var files: [URL] { get }
    
    func log(message: Message)
    
}
