//
//  KindKit
//

import Foundation

extension UI.Container.Screen {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        
        var content: IUIView? {
            didSet {
                guard self.content !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var bar: UI.View.Bar? {
            didSet {
                guard self.bar !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var barSize: Size?
        
        init() {
        }
        
        func layout(bounds: Rect) -> Size {
            if let content = self.content {
                content.frame = bounds
            }
            if let bar = self.bar {
                let barSize = bar.size(available: bounds.size)
                switch bar.placement {
                case .top: bar.frame = .init(top: bounds.top, size: barSize)
                case .bottom: bar.frame = .init(bottom: bounds.bottom, size: barSize)
                }
                self.barSize = barSize
            }
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            if let content = self.content {
                let itemSize = content.size(available: available)
                return itemSize
            }
            return .zero
        }
        
        func views(bounds: Rect) -> [IUIView] {
            if let content = self.content, let bar = self.bar {
                return [ content, bar ]
            } else if let content = self.content {
                return [ content ]
            } else if let bar = self.bar {
                return [ bar ]
            }
            return []
        }
        
    }
    
}
