//
//  KindKit
//

import Foundation

public extension UI.Layout.State {
    
    struct Data {
        
        public var inset: InsetFloat
        public var alignment: Alignment
        public var item: UI.Layout.Item?
        public var view: IUIView? {
            set(value) { self.item = value.flatMap({ UI.Layout.Item($0) }) }
            get { return self.item?.view }
        }
        
        public init(
            inset: InsetFloat = .zero,
            alignment: Alignment = .topLeft,
            item: UI.Layout.Item? = nil
        ) {
            self.inset = inset
            self.alignment = alignment
            self.item = item
        }
        
        public init(
            inset: InsetFloat = .zero,
            alignment: Alignment = .topLeft,
            view: IUIView
        ) {
            self.inset = inset
            self.alignment = alignment
            self.item = UI.Layout.Item(view)
        }
        
    }
    
}
