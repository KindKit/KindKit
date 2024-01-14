//
//  KindKit
//

import Foundation

public protocol IMessage {
    
    var id: String { get }
    var date: Date { get }
    var level: Level { get }
    var category: String { get }
    
    func string(options: Message.Options) -> String
    
}
