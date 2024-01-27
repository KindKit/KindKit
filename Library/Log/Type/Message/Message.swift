//
//  KindKit
//

import Foundation

public protocol Message : Sendable {
    
    var id: String { get }
    var date: Date { get }
    var level: Level { get }
    var category: String { get }
    
    func string(options: Options) -> String
    
}
