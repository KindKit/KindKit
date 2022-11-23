//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UI.View.Input {

    struct Keyboard : Equatable {
        
        public var type: UIKeyboardType
        public var appearance: UIKeyboardAppearance
        public var autocapitalization: UITextAutocapitalizationType
        public var autocorrection: UITextAutocorrectionType
        public var spellChecking: UITextSpellCheckingType
        public var returnKey: UIReturnKeyType
        public var enablesReturnKeyAutomatically: Bool
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
