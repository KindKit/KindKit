//
//  KindKit
//

import Foundation

public protocol ILogTarget : AnyObject {
    
    var files: [URL] { get }
    
    func log(message: ILogMessage)
    
}
