//
//  KindKit
//

import KindMath

extension StateLayout {
    
    public struct Data {
        
        public var inset: Inset
        public var alignment: Alignment
        public var view: IView?
        
        public init(
            inset: Inset = .zero,
            alignment: Alignment = .topLeft,
            view: IView? = nil
        ) {
            self.inset = inset
            self.alignment = alignment
            self.view = view
        }
        
    }
    
}
