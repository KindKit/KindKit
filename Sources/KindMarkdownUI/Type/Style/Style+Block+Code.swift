//
//  KindKit
//

import KindEvent
import KindGraphics
import KindMath

public extension Style.Block {
    
    final class Code {
        
        public var inset: Inset = .init(top: 24, left: 0, right: 0, bottom: 0) {
            didSet {
                guard self.inset != oldValue else { return }
                self._change()
            }
        }
        public var panelCornerRadius: CornerRadius = .manual(radius: 8) {
            didSet {
                guard self.panelCornerRadius != oldValue else { return }
                self._change()
            }
        }
        public var panelBorder: Border = .none {
            didSet {
                guard self.panelBorder != oldValue else { return }
                self._change()
            }
        }
        public var panelColor: Color = .gunmetalGray {
            didSet {
                guard self.panelColor != oldValue else { return }
                self._change()
            }
        }
        public var contentInset: Inset = .init(horizontal: 8, vertical: 8) {
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

private extension Style.Block.Code {
    
    @inline(__always)
    func _change() {
        self.onChanged.emit()
    }
    
}

public extension Style.Block.Code {
    
    @inlinable
    func inset(_ value: Inset) -> Self {
        self.inset = value
        return self
    }
    
    @inlinable
    func panelCornerRadius(_ value: CornerRadius) -> Self {
        self.panelCornerRadius = value
        return self
    }
    
    @inlinable
    func panelBorder(_ value: Border) -> Self {
        self.panelBorder = value
        return self
    }
    
    @inlinable
    func panelColor(_ value: Color) -> Self {
        self.panelColor = value
        return self
    }
    
    @inlinable
    func contentInset(_ value: Inset) -> Self {
        self.contentInset = value
        return self
    }

}

