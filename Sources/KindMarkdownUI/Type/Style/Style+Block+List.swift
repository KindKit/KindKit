//
//  KindKit
//

import KindEvent
import KindMath

public extension Style.Block {
    
    final class List {
        
        public var markerInset: Inset = .init(top: 12, left: 4, right: 4, bottom: 0) {
            didSet {
                guard self.markerInset != oldValue else { return }
                self._change()
            }
        }
        public var contentInset: Inset = .init(top: 12, left: 4, right: 4, bottom: 0) {
            didSet {
                guard self.contentInset != oldValue else { return }
                self._change()
            }
        }
        public let onChanged = Signal< Void, Void >()
        
        public init() {
        }
        
    }
    
}

private extension Style.Block.List {
    
    @inline(__always)
    func _change() {
        self.onChanged.emit()
    }
    
}

public extension Style.Block.List {
    
    @inlinable
    func markerInset(_ value: Inset) -> Self {
        self.markerInset = value
        return self
    }
    
    @inlinable
    func contentInset(_ value: Inset) -> Self {
        self.contentInset = value
        return self
    }

}

