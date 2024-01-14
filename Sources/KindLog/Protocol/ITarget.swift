//
//  KindKit
//

import Foundation

public protocol ITarget : AnyObject {
    
    var files: [URL] { get }
    
    func log(message: IMessage)
    
}
