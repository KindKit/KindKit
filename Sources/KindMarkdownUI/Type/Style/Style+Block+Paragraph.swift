//
//  KindKit
//

import KindEvent
import KindMath

public extension Style.Block {
    
    final class Paragraph {
        
        public var inset: Inset = .init(top: 24, left: 0, right: 0, bottom: 0) {
            didSet {
                guard self.inset != oldValue else { return }
                self._change()
            }
        }
        public let onChanged = Signal< Void, Void >()
        
        public init() {
        }
        
    }
    
}

private extension Style.Block.Paragraph {
    
    @inline(__always)
    func _change() {
        self.onChanged.emit()
    }
    
}

public extension Style.Block.Paragraph {
    
    @inlinable
    func inset(_ value: Inset) -> Self {
        self.inset = value
        return self
    }
    
}

