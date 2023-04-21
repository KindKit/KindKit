//
//  KindKit
//

import Foundation

public extension UI.Markdown.Style.Block {
    
    final class Code {
        
        public var inset = Inset(top: 24, left: 0, right: 0, bottom: 0) {
            didSet {
                guard self.inset != oldValue else { return }
                self._change()
            }
        }
        public var panelCornerRadius = UI.CornerRadius.manual(radius: 6) {
            didSet {
                guard self.panelCornerRadius != oldValue else { return }
                self._change()
            }
        }
        public var panelBorder = UI.Border.none {
            didSet {
                guard self.panelBorder != oldValue else { return }
                self._change()
            }
        }
        public var panelColor = UI.Color.lightGray {
            didSet {
                guard self.panelColor != oldValue else { return }
                self._change()
            }
        }
        public var contentInset = Inset(horizontal: 8, vertical: 8) {
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

private extension UI.Markdown.Style.Block.Code {
    
    @inline(__always)
    func _change() {
        self.onChanged.emit()
    }
    
}

public extension UI.Markdown.Style.Block.Code {
    
    @inlinable
    func inset(_ value: Inset) -> Self {
        self.inset = value
        return self
    }
    
    @inlinable
    func panelCornerRadius(_ value: UI.CornerRadius) -> Self {
        self.panelCornerRadius = value
        return self
    }
    
    @inlinable
    func panelBorder(_ value: UI.Border) -> Self {
        self.panelBorder = value
        return self
    }
    
    @inlinable
    func panelColor(_ value: UI.Color) -> Self {
        self.panelColor = value
        return self
    }
    
    @inlinable
    func contentInset(_ value: Inset) -> Self {
        self.contentInset = value
        return self
    }

}

