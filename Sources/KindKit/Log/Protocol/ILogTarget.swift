//
//  KindKit
//

import Foundation

public protocol ILogTarget : AnyObject {
    
    var files: [URL] { get }
    
    func log(level: Log.Level, category: String, message: String)
    
}
