//
//  KindKit
//

import Foundation

public extension UI.Markdown.Style.Block {
    
    final class Heading {
        
        public var inset: Inset = .init(top: 24, left: 0, right: 0, bottom: 0) {
            didSet {
                guard self.inset != oldValue else { return }
                self._change()
            }
        }
        public let onChanged = Signal.Empty< Void >()
        
        public init() {
        }
        
    }
    
}

private extension UI.Markdown.Style.Block.Heading {
    
    @inline(__always)
    func _change() {
        self.onChanged.emit()
    }
    
}

public extension UI.Markdown.Style.Block.Heading {
    
    @inlinable
    func inset(_ value: Inset) -> Self {
        self.inset = value
        return self
    }

}

