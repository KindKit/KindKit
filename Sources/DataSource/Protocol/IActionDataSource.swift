//
//  KindKit
//

import Foundation

public protocol IActionDataSource : IDataSource {
    
    associatedtype Params
    
    var isPerforming: Bool { get }
    
    func perform(params: Params)
    
}

public extension IActionDataSource {
    
    func perform() where Params == Void {
        self.perform(params: ())
    }
    
}
