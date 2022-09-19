//
//  KindKit
//

import Foundation

public protocol ILogTarget : AnyObject {
    
    var enabled: Bool { set get }
    
    func log(level: Log.Level, category: String, message: String)
    
}
