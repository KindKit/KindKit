//
//  KindKit
//

import Foundation

public extension UI.Screen.Modal.Presentation {
    
    struct Sheet {
        
        public let inset: Inset
        public let background: IUIView & IUIViewAlphable
        
        public init(
            _ background: IUIView & IUIViewAlphable
        ) {
            self.init(
                inset: .zero,
                background: background
            )
        }
        
        public init(
            inset: Inset,
            background: IUIView & IUIViewAlphable
        ) {
            self.inset = inset
            self.background = background
        }
        
    }
    
}
