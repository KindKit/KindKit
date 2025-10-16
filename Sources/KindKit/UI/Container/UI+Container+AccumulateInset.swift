//
//  KindKit
//

import Foundation

public extension UI.Container {
    
    @available(*, deprecated, renamed: "UI.Container.InheritedInset")
    typealias AccumulateInset = InheritedInset

    struct InheritedInset : Equatable {
        
        public var device: Inset
        public var virtualKeyboard: Inset
        public var content: Content
        
        public init(
            device: Inset,
            virtualKeyboard: Inset,
            content: Content
        ) {
            self.device = device
            self.virtualKeyboard = virtualKeyboard
            self.content = content
        }
        
    }

}

public extension UI.Container.InheritedInset {
    
    static var zero: Self {
        return .init(device: .zero, virtualKeyboard: .zero, content: .zero)
    }
    
}

public extension UI.Container.InheritedInset {
    
    var natural: Inset {
        return self.get([ .device, .virtualKeyboard, .contentStatic ])
    }
    
    var interactive: Inset {
        return self.get([ .device, .virtualKeyboard, .contentInteractive ])
    }
    
}

public extension UI.Container.InheritedInset {
    
    func get(_ options: Options) -> Inset {
        var result = Inset.zero
        if options.contains(.device) {
            result += self.device
        }
        if options.contains(.contentInteractive) {
            result += self.content.interactive
        } else if options.contains(.contentStatic) {
            result += self.content.static
        }
        if options.contains(.virtualKeyboard) {
            result = .init(
                top: max(result.top, self.virtualKeyboard.top),
                left: max(result.left, self.virtualKeyboard.left),
                right: max(result.right, self.virtualKeyboard.right),
                bottom: max(result.bottom, self.virtualKeyboard.bottom)
            )
        }
        return result
    }
    
}

extension UI.Container.InheritedInset : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            device: self.device.lerp(to.device, progress: progress),
            virtualKeyboard: self.virtualKeyboard.lerp(to.virtualKeyboard, progress: progress),
            content: self.content.lerp(to.content, progress: progress)
        )
    }
    
}
