//
//  KindKit
//

import Foundation

public extension UI.Screen.Modal {
    
    enum Presentation {
        
        case simple
        case sheet(UI.Modal.Presentation.Sheet)
        
    }
    
}

public extension UI.Screen.Modal.Presentation {
    
    static func sheet(
        inset: Inset = .zero,
        cornerRadius: UI.CornerRadius = .none,
        detents: [UI.Size.Dynamic.Dimension] = [ .fit ],
        preferredDetent: UI.Size.Dynamic.Dimension? = nil,
        background: IUIView & IUIViewAlphable,
        grabber: IUIView? = nil,
        grabberInset: Inset = .init(horizontal: 8, vertical: 8)
    ) -> Self {
        return .sheet(UI.Modal.Presentation.Sheet(
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
