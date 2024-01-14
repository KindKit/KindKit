//
//  KindKit
//

import KindGraphics
import KindUI

public extension Modal.Presentation {
    
    struct Sheet {
        
        public let inset: Inset
        public let cornerRadius: CornerRadius
        public let detents: [DynamicSize.Dimension]
        public let preferredDetent: DynamicSize.Dimension
        public let background: IView & IViewAlphable
        public let grabber: IView?
        public let grabberInset: Inset

        public init(
            inset: Inset,
            cornerRadius: CornerRadius,
            detents: [DynamicSize.Dimension],
            preferredDetent: DynamicSize.Dimension? = nil,
            background: IView & IViewAlphable,
            grabber: IView? = nil,
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

public extension Modal.Presentation.Sheet {
    
    @inlinable
    var minimalDetent: DynamicSize.Dimension {
        self.detents.first ?? self.preferredDetent
    }
    
    @inlinable
    var maximalDetent: DynamicSize.Dimension {
        self.detents.last ?? self.preferredDetent
    }
    
}
