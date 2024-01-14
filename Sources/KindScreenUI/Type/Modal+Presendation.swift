//
//  KindKit
//

import KindUI

extension Modal {
    
    public enum Presentation {
        
        case simple
        case sheet(Sheet)
        
    }
    
}

public extension Modal.Presentation {
    
    static func sheet(
        inset: Inset = .zero,
        cornerRadius: CornerRadius = .none,
        detents: [DynamicSize.Dimension] = [ .fit ],
        preferredDetent: DynamicSize.Dimension? = nil,
        background: IView & IViewAlphable,
        grabber: IView? = nil,
        grabberInset: Inset = .init(horizontal: 8, vertical: 8)
    ) -> Self {
        return .sheet(Modal.Presentation.Sheet(
            inset: inset,
            cornerRadius: cornerRadius,
            detents: detents,
            preferredDetent: preferredDetent,
            background: background,
            grabber: grabber,
            grabberInset: grabberInset
        ))
    }
    
}
