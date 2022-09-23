//
//  KindKit
//

import Foundation

public extension UI.Screen.Modal.Presentation {
    
    struct Sheet {
        
        public let inset: InsetFloat
        public let background: IUIView & IUIViewAlphable
        
        public init(
            inset: InsetFloat,
            background: IUIView & IUIViewAlphable
        ) {
            self.inset = inset
            self.background = background
        }
        
    }
    
}
