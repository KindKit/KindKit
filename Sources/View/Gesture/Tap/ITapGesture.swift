//
//  KindKitView
//

import Foundation
import KindKitCore

public protocol ITapGesture : IGesture {
    
    var numberOfTapsRequired: UInt { set get }
    var numberOfTouchesRequired: UInt { set get }
    
    @discardableResult
    func numberOfTapsRequired(_ value: UInt) -> Self
    
    @discardableResult
    func numberOfTouchesRequired(_ value: UInt) -> Self
    
    @discardableResult
    func onTriggered(_ value: (() -> Void)?) -> Self
    
}
