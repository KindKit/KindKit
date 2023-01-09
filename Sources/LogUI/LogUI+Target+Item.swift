//
//  KindKit
//

import Foundation

extension LogUI.Target {
    
    struct Item : Equatable {
        
        let date: Date
        let level: Log.Level
        let category: String
        let message: String
        
    }
    
}
