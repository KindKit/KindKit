//
//  KindKit
//

import Foundation

public extension UI.Modal.Presentation {
    
    struct Sheet {
        
        public let inset: Inset
        public let cornerRadius: UI.CornerRadius
        public let detents: [UI.Size.Dynamic.Dimension]
        public let preferredDetent: UI.Size.Dynamic.Dimension
        public let background: IUIView & IUIViewAlphable
        
        public init(
            inset: Inset,
            cornerRadius: UI.CornerRadius,
            detents: [UI.Size.Dynamic.Dimension],
            preferredDetent: UI.Size.Dynamic.Dimension?,
            background: IUIView & IUIViewAlphable
        ) {
            self.inset = inset
            self.cornerRadius = cornerRadius
            if detents.isEmpty == false {
                self.detents = detents
            } else {
                self.detents = [ .fit ]
            }
            if let preferredDetent = preferredDetent {
                self.preferredDetent = preferredDetent
            } else {
                self.preferredDetent = self.detents[0]
            }
            self.background = background
        }
        
    }
    
}

public extension UI.Modal.Presentation.Sheet {
    
    @inlinable
    var minimalDetent: UI.Size.Dynamic.Dimension {
        self.detents.first ?? self.preferredDetent
    }
    
    @inlinable
    var maximalDetent: UI.Size.Dynamic.Dimension {
        self.detents.last ?? self.preferredDetent
    }
    
}
