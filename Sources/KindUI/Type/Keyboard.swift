//
//  KindKit
//

import Foundation
#if os(macOS)
import AppKit
#endif
import KindMath

public struct Keyboard : Equatable, Hashable {
    
    public let code: UInt16
    public let characters: String?
    public let charactersWithoutModifiers: String?
    public let modifiers: Modifiers
    
}

#if os(macOS)

public extension Keyboard {
    
    static func with(_ nsEvent: NSEvent) -> Self {
        return .init(
            code: nsEvent.keyCode,
            characters: nsEvent.characters,
            charactersWithoutModifiers: nsEvent.charactersIgnoringModifiers,
            modifiers: .with(flags: nsEvent.modifierFlags)
        )
    }
    
}

#endif
