//
//  KindKit
//

import Foundation

public protocol ILogMessage {
    
    var id: String { get }
    var date: Date { get }
    var level: Log.Level { get }
    var category: String { get }
    
    func string(options: Log.Message.Options) -> String
    
}
