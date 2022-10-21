//
//  KindKit
//

import Foundation

extension UI.View.Cell {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var background: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate() }
        }
        var content: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate() }
        }
        
        init() {
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            self.background?.frame = bounds
            self.content?.frame = bounds
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            guard let content = self.content else { return .zero }
            let contentSize = content.size(available: available)
            return Size(width: available.width, height: contentSize.height)
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            if let background = self.background, let content = self.content {
                return [ background, content ]
            } else if let background = self.background {
                return [ background ]
            } else if let content = self.content {
                return [ content ]
            }
            return []
        }
        
    }
    
}
