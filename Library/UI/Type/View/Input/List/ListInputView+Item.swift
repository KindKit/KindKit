//
//  KindKit
//

#if os(iOS)

import KindText
import KindMonadicMacro

extension ListInputView {
    
    @Monadic
    public final class Item {
        
        @MonadicField
        public var style: Style? {
            set { self.attributed.style = newValue ?? .label }
            get { self.attributed.style }
        }
        
        @MonadicField
        public var text: Text {
            set { self.attributed.text = newValue }
            get { self.attributed.text }
        }
        
        public let value: Value
        
        internal let attributed: AttributedText
        
        public init(
            style: Style? = nil,
            text: Text,
            value: Value
        ) {
            self.attributed = .init(
                style: style ?? .label,
                text: text
            )
            self.value = value
        }
        
    }
    
}

extension ListInputView.Item : Equatable {
    
    public static func == (lhs: ListInputView.Item, rhs: ListInputView.Item) -> Bool {
        return lhs.style == rhs.style && lhs.text == rhs.text && lhs.value == rhs.value
    }
    
}

#endif
