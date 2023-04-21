//
//  KindKit
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public extension UI.Markdown.Style {
    
    final class Text {
        
        public var normal: UI.Markdown.Style.Text.Specific {
            didSet {
                guard self.normal !== oldValue else { return }
                self._subscribe(normal: self.normal)
                self._change()
            }
        }
        public var link: UI.Markdown.Style.Text.Specific {
            didSet {
                guard self.link !== oldValue else { return }
                self._subscribe(link: self.link)
                self._change()
            }
        }
        public let onChanged = Signal.Empty< Void >()
        
        private var _normalChangeListner: ICancellable?
        private var _linkChangeListner: ICancellable?
        
        public init(
            normal: UI.Markdown.Style.Text.Specific,
            link: UI.Markdown.Style.Text.Specific
        ) {
            self.normal = normal
            self.link = link
            self._subscribe(normal: normal)
            self._subscribe(link: link)
        }
        
    }
    
}

private extension UI.Markdown.Style.Text {
    
    func _subscribe(normal: UI.Markdown.Style.Text.Specific) {
        self._normalChangeListner = normal.onChanged.subscribe(self, { $0._onChange() }).autoCancel()
    }
    
    func _subscribe(link: UI.Markdown.Style.Text.Specific) {
        self._linkChangeListner = link.onChanged.subscribe(self, { $0._onChange() }).autoCancel()
    }
    
    @inline(__always)
    func _change() {
        self.onChanged.emit()
    }
    
    func _onChange() {
        self._change()
    }
    
}

public extension UI.Markdown.Style.Text {
    
    @inlinable
    func normal(_ value: UI.Markdown.Style.Text.Specific) -> Self {
        self.normal = value
        return self
    }
    
    @inlinable
    func link(_ value: UI.Markdown.Style.Text.Specific) -> Self {
        self.link = value
        return self
    }
    
}
