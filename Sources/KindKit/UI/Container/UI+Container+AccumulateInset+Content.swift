//
//  KindKit
//

import Foundation

public extension UI.Container.InheritedInset {

    struct Content : Equatable {
        
        public var `static`: Inset
        public var interactive: Inset
        
        public init(
            top: Double,
            left: Double,
            right: Double,
            bottom: Double
        ) {
            self.static = .init(top: top, left: left, right: right, bottom: bottom)
            self.interactive = .init(top: top, left: left, right: right, bottom: bottom)
        }
        
        public init(
            horizontal: Double,
            vertical: Double
        ) {
            self.static = .init(horizontal: horizontal, vertical: vertical)
            self.interactive = .init(horizontal: horizontal, vertical: vertical)
        }
        
        public init(
            `static`: Inset,
            interactive: Inset
        ) {
            self.static = `static`
            self.interactive = interactive
        }
        
    }

}

public extension UI.Container.InheritedInset.Content {
    
    static var zero: Self {
        return .init(static: .zero, interactive: .zero)
    }
    
}

public extension UI.Container.InheritedInset.Content {
    
    func setting(top: Double) -> Self {
        return .init(
            static: .init(
                top: top,
                left: self.static.left,
                right: self.static.right,
                bottom: self.static.bottom
            ),
            interactive: .init(
                top: top,
                left: self.static.left,
                right: self.static.right,
                bottom: self.static.bottom
            )
        )
    }
    
    func appending(top: Double) -> Self {
        return .init(
            static: .init(
                top: self.static.top + top,
                left: self.static.left,
                right: self.static.right,
                bottom: self.static.bottom
            ),
            interactive: .init(
                top: self.static.top + top,
                left: self.static.left,
                right: self.static.right,
                bottom: self.static.bottom
            )
        )
    }
    
    func appending(top: Double, visibility: Double) -> Self {
        return .init(
            static: .init(
                top: self.static.top + top,
                left: self.static.left,
                right: self.static.right,
                bottom: self.static.bottom
            ),
            interactive: .init(
                top: self.static.top + (top * visibility),
                left: self.static.left,
                right: self.static.right,
                bottom: self.static.bottom
            )
        )
    }
    
}

public extension UI.Container.InheritedInset.Content {
    
    func setting(bottom: Double) -> Self {
        return .init(
            static: .init(
                top: self.static.top,
                left: self.static.left,
                right: self.static.right,
                bottom: bottom
            ),
            interactive: .init(
                top: self.static.top,
                left: self.static.left,
                right: self.static.right,
                bottom: bottom
            )
        )
    }
    
    func appending(bottom: Double) -> Self {
        return .init(
            static: .init(
                top: self.static.top,
                left: self.static.left,
                right: self.static.right,
                bottom: self.static.bottom + bottom
            ),
            interactive: .init(
                top: self.static.top,
                left: self.static.left,
                right: self.static.right,
                bottom: self.static.bottom + bottom
            )
        )
    }
    
    func appending(bottom: Double, visibility: Double) -> Self {
        return .init(
            static: .init(
                top: self.static.top,
                left: self.static.left,
                right: self.static.right,
                bottom: self.static.bottom + bottom
            ),
            interactive: .init(
                top: self.static.top,
                left: self.static.left,
                right: self.static.right,
                bottom: self.static.bottom + (bottom * visibility)
            )
        )
    }
    
}

extension UI.Container.InheritedInset.Content : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            static: self.static.lerp(to.static, progress: progress),
            interactive: self.interactive.lerp(to.interactive, progress: progress)
        )
    }
    
}
