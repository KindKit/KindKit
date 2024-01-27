//
//  KindKit
//

import Foundation

public protocol Action : Base {
    
    associatedtype Params
    
    var isPerforming: Bool { get }
    
    func perform(params: Params)
    
}

public extension Action {
    
    func perform() where Params == Void {
        self.perform(params: ())
    }
    
}
