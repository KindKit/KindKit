//
//  KindKit
//

import Foundation
import KindEvent
import KindGraphics
import KindMonadicMacro

@Monadic
public final class Text {
    
    public var attributed: NSAttributedString {
        if self._attributed == nil {
            self._attributed = .kk_make(self)
        }
        return self._attributed!
    }
    
    @MonadicField
    public var style: Style {
        didSet {
            guard self.style != oldValue else { return }
            oldValue.onChanged(disconnect: self)
            self.style.onChanged(target: self, regular: { $0._onChanged() })
            self._onChanged()
        }
    }
    
    @MonadicField
    public var text: Text.Part = .init() {
        didSet {
            guard self.text != oldValue else { return }
            for textStyle in oldValue.styles {
                textStyle.onChanged(disconnect: self)
            }
            for textStyle in self.text.styles {
                textStyle.onChanged(target: self, regular: { $0._onChanged() })
            }
            self._onChanged()
        }
    }
    
    @MonadicSignal
    public let onChanged = Signal< Void, Void >()
    
    private var _attributed: NSAttributedString?
    
    public init(
        style: Style,
        text: Part
    ) {
        self.style = style
        self.text = text
        
        self._setup()
    }
    
    public init(
        style: Style,
        @ComponentsBuilder builder: () -> [any Component]
    ) {
        self.style = style
        self.text = .init(builder)
        
        self._setup()
    }
    
    deinit {
        self._destroy()
    }
    
}

fileprivate extension Text {
    
    func _setup() {
        self.style.onChanged(target: self, regular: { $0._onChanged() })
        for textStyle in self.text.styles {
            textStyle.onChanged(target: self, regular: { $0._onChanged() })
        }
    }

    func _destroy() {
        for textStyle in self.text.styles {
            textStyle.onChanged(disconnect: self)
        }
        self.style.onChanged(disconnect: self)
    }

}

extension Text : Equatable {
    
    public static func == (lhs: Text, rhs: Text) -> Bool {
        return lhs.style == rhs.style && lhs.text == rhs.text
    }
    
}

extension Text : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.style)
        hasher.combine(self.text)
    }
    
}

fileprivate extension Text {
    
    func _onChanged() {
        self._attributed = nil
        self.onChanged.emit()
    }
    
}
