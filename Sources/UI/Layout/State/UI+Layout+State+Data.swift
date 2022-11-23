//
//  KindKit
//

import Foundation

public extension UI.Layout.State {
    
    struct Data {
        
        public var inset: Inset
        public var alignment: Alignment
        public var view: IUIView?
        
        public init(
            inset: Inset = .zero,
            alignment: Alignment = .topLeft,
            view: IUIView? = nil
        ) {
            self.inset = inset
            self.alignment = alignment
            self.view = view
        }
        
    }
    
}
