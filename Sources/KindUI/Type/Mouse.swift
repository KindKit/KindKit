//
//  KindKit
//

#if os(macOS)
import AppKit
#endif
import KindMath

public struct Mouse : Equatable {
    
    public let location: Point
    public let buttons: [Button]
    
}

public extension Mouse {
    
    func contains(button: Button) -> Bool {
        return self.buttons.contains(button)
    }
    
}

#if os(macOS)

public extension Mouse {
    
    static func with(_ nsEvent: NSEvent) -> Self {
        self.init(
            location: .init(nsEvent.locationInWindow),
            buttons: .with(nsEvent)
        )
    }
    
}

#endif
