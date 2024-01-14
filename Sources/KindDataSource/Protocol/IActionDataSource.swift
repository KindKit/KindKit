//
//  KindKit
//

import Foundation

public protocol IAction : IBase {
    
    associatedtype Params
    
    var isPerforming: Bool { get }
    
    func perform(params: Params)
    
}

public extension IAction {
    
    func perform() where Params == Void {
        self.perform(params: ())
    }
    
}
