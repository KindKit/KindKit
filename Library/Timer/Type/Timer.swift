//
//  KindKit
//

import Foundation
import KindEvent
import KindMonadicMacro

@Monadic
public protocol Timer : Equatable, CancelTrait {
    
    var queue: DispatchQueue { get }
    
    var isRunning: Bool { get }
    
    @MonadicSignal
    var onStarted: Signal< Void, Void > { get }
    
    @MonadicSignal
    var onTriggered: Signal< Void, Void > { get }
    
}

extension Timer {
    
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs
    }
    
}
