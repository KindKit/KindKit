//
//  KindKit
//

#if os(iOS)

import UIKit
import KindMonadicMacro

extension VirtualInput {
    
    @Monadic
    public struct Style : Equatable {
        
        @MonadicField
        public var type: UIKeyboardType
        
        @MonadicField
        public var appearance: UIKeyboardAppearance
        
        @MonadicField
        public var autocapitalization: UITextAutocapitalizationType
        
        @MonadicField
        public var autocorrection: UITextAutocorrectionType
        
        @MonadicField
        public var spellChecking: UITextSpellCheckingType
        
        @MonadicField
        public var returnKey: UIReturnKeyType
        
        @MonadicField
        public var enablesReturnKeyAutomatically: Bool
        
        @MonadicField
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
