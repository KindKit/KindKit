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
        public let grabber: IUIView?
        public let grabberInset: Inset

        public init(
            inset: Inset,
            cornerRadius: UI.CornerRadius,
            detents: [UI.Size.Dynamic.Dimension],
            preferredDetent: UI.Size.Dynamic.Dimension? = nil,
            background: IUIView & IUIViewAlphable,
            grabber: IUIView? = nil,
            grabberInset: Inset = .init(horizontal: 8, vertical: 8)
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
            self.grabber = grabber
            self.grabberInset = grabberInset
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
