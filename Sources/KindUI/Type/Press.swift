//
//  KindKit
//

import KindTime

public enum Press {
    
    case mouse(Mouse.Click)
    case tap(Touch.Tap)
    
}

public extension Press {
    
    @inlinable
    static func mouse(
        location: Point,
        button: Mouse.Button,
        duration: SecondsInterval
    ) -> Self {
        return .mouse(.init(
            location: location,
            button: button,
            duration: duration
        ))
    }
    
    @inlinable
    static func tap(
        location: Point
    ) -> Self {
        return .tap(.init(
            location: location
        ))
    }
    
}
