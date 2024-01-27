//
//  KindKit
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindMath

public struct Touch : Equatable, Hashable {
    
    public let uuid: UUID
    public let location: Point
    public let phase: Phase
    
    public init(
        uuid: UUID = .init(),
        location: Point,
        phase: Phase
    ) {
        self.uuid = uuid
        self.location = location
        self.phase = phase
    }
    
    public init(
        uuid: UUID = .init(),
        touch: NativeTouch,
        view: NativeView
    ) {
        self.uuid = uuid
        self.location = .init(touch.location(in: view))
        if let phase = Phase.with(touch.phase) {
            self.phase = phase
        } else {
            self.phase = .began
        }
    }
    
}

extension Touch {
    
    func update(_ touch: NativeTouch, view: NativeView) -> Self {
        return .init(
            uuid: self.uuid,
            location: .init(touch.location(in: view)),
            phase: Phase.with(touch.phase) ?? self.phase
        )
    }
    
}
