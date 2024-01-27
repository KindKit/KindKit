//
//  KindKit
//

import KindMath

public extension ScrollHideableBar {
    
    enum State : Equatable {
        
        case show
        case hide
        case hiding(Percent)
        
    }
    
}

public extension ScrollHideableBar.State {
    
    @inlinable
    static func hiding< InputType : BinaryFloatingPoint >(_ current: InputType, from: InputType) -> Self {
        return .hiding(.init(current, from: from))
    }
    
}

public extension ScrollHideableBar.State {
    
    var isBoundary: Bool {
        switch self {
        case .show, .hide: return true
        case .hiding: return false
        }
    }
    
}

public extension ScrollHideableBar.State {
    
    func proposition(
        threshold: Double,
        anchor: Double,
        viewSize: Double,
        contentOffset: Double,
        contentSize: Double
    ) -> Self {
        let delta: Double
        if contentOffset > threshold / 2 {
            delta = anchor - contentOffset
        } else {
            delta = 0
        }
        switch self {
        case .show:
            if delta < 0 {
                if delta < -threshold {
                    return .hide
                }
                return .hiding(-delta, from: threshold)
            }
            return .show
        case .hide:
            if delta > 0 {
                if delta > threshold {
                    return .show
                }
                return .hiding(threshold - delta, from: threshold)
            }
            return .hide
        case .hiding:
            if delta < 0 {
                if delta < -threshold {
                    return .hide
                }
                return .hiding(-delta, from: threshold)
            }
            return .show
        }
    }
    
}
