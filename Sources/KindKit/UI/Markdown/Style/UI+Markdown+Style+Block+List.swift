//
//  KindKit
//

import Foundation

public extension UI.Markdown.Style.Block {
    
    final class List {
        
        public var markerInset = Inset(top: 12, left: 4, right: 4, bottom: 0) {
            didSet {
                guard self.markerInset != oldValue else { return }
                self._change()
            }
        }
        public var contentInset = Inset(top: 12, left: 4, right: 4, bottom: 0) {
            didSet {
                guard self.contentInset != oldValue else { return }
                self._change()
            }
        }
        public let onChanged = Signal.Empty< Void >()
        
        public init() {
        }
        
    }
    
}

private extension UI.Markdown.Style.Block.List {
    
    @inline(__always)
    func _change() {
        self.onChanged.emit()
    }
    
}

public extension UI.Markdown.Style.Block.List {
    
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

