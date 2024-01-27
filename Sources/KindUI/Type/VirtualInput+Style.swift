//
//  KindKit
//

#if os(iOS)

import UIKit
import KindMonadicMacro

extension VirtualInput {
    
    @KindMonadic
    public struct Style : Equatable {
        
        @KindMonadicProperty
        public var type: UIKeyboardType
        
        @KindMonadicProperty
        public var appearance: UIKeyboardAppearance
        
        @KindMonadicProperty
        public var autocapitalization: UITextAutocapitalizationType
        
        @KindMonadicProperty
        public var autocorrection: UITextAutocorrectionType
        
        @KindMonadicProperty
        public var spellChecking: UITextSpellCheckingType
        
        @KindMonadicProperty
        public var returnKey: UIReturnKeyType
        
        @KindMonadicProperty
        public var enablesReturnKeyAutomatically: Bool
        
        @KindMonadicProperty
        public var textContent: UITextContentType?
        
        public init(
            type: UIKeyboardType = .default,
            appearance: UIKeyboardAppearance = .default,
            autocapitalization: UITextAutocapitalizationType = .sentences,
            autocorrection: UITextAutocorrectionType = .default,
            spellChecking: UITextSpellCheckingType = .default,
            returnKey: UIReturnKeyType = .continue,
            enablesReturnKeyAutomatically: Bool = true,
            textContent: UITextContentType? = nil
        ) {
            self.type = type
            self.appearance = appearance
            self.autocapitalization = autocapitalization
            self.autocorrection = autocorrection
            self.spellChecking = spellChecking
            self.returnKey = returnKey
            self.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically
            self.textContent = textContent
        }
        
    }
    
}

#endif
