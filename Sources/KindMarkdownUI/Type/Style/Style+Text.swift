//
//  KindKit
//

import KindEvent
import KindRichString

public extension Style {
    
    final class Text {
        
        public var normal: KindRichString.Style {
            didSet {
                guard self.normal !== oldValue else { return }
                self._subscribe(normal: self.normal)
                self._change()
            }
        }
        public var link: KindRichString.Style {
            didSet {
                guard self.link !== oldValue else { return }
                self._subscribe(link: self.link)
                self._change()
            }
        }
        public let onChanged = Signal< Void, Void >()
        
        private var _normalChangeListner: ICancellable?
        private var _linkChangeListner: ICancellable?
        
        public init(
            normal: Style.Text.Specific,
            link: Style.Text.Specific
        ) {
            self.normal = normal
            self.link = link
            self._subscribe(normal: normal)
            self._subscribe(link: link)
        }
        
    }
    
}

private extension Style.Text {
    
    func _subscribe(normal: KindRichString.Style) {
        self._normalChangeListner = normal.onChanged.add(self, { $0._onChange() }).autoCancel()
    }
    
    func _subscribe(link: KindRichString.Style) {
        self._linkChangeListner = link.onChanged.add(self, { $0._onChange() }).autoCancel()
    }
    
    @inline(__always)
    func _change() {
        self.onChanged.emit()
    }
    
    func _onChange() {
        self._change()
    }
    
}

public extension Style.Text {
    
    @inlinable
    func normal(_ value: KindRichString.Style) -> Self {
        self.normal = value
        return self
    }
    
    @inlinable
    func link(_ value: KindRichString.Style) -> Self {
        self.link = value
        return self
    }
    
}
