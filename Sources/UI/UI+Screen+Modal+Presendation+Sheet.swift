//
//  KindKit
//

import Foundation

public extension UI.Screen.Modal.Presentation {
    
    struct Sheet {
        
        public let inset: InsetFloat
        public let backgroundView: IUIView & IUIViewAlphable
        
        public init(
            inset: InsetFloat,
            backgroundView: IUIView & IUIViewAlphable
        ) {
            self.inset = inset
            self.backgroundView = backgroundView
        }
        
    }
    
}
