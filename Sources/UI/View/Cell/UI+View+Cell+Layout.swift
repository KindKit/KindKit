//
//  KindKit
//

import Foundation

extension UI.View.Cell {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        var background: IUIView? {
            didSet { self.setNeedForceUpdate() }
        }
        var content: IUIView? {
            didSet { self.setNeedForceUpdate() }
        }
        
        init() {
        }
        
        func layout(bounds: Rect) -> Size {
            self.background?.frame = bounds
            self.content?.frame = bounds
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            guard let content = self.content else { return .zero }
            let contentSize = content.size(available: available)
            return Size(width: available.width, height: contentSize.height)
        }
        
        func views(bounds: Rect) -> [IUIView] {
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
