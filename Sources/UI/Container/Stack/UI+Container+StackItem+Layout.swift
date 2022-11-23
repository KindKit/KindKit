//
//  KindKit
//

import Foundation

extension UI.Container.StackItem {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        var bar: IUIView {
            didSet {
                guard self.bar !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var barVisibility: Double {
            didSet {
                guard self.barVisibility != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var barHidden: Bool {
            didSet {
                guard self.barHidden != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var barOffset: Double = 0 {
            didSet {
                guard self.barOffset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        private(set) var barSize: Double = 0
        let content: IUIView
        
        init(
            bar: IUIView,
            barVisibility: Double,
            barHidden: Bool,
            barOffset: Double,
            content: IUIView
        ) {
            self.bar = bar
            self.barVisibility = barVisibility
            self.barHidden = barHidden
            self.barOffset = barOffset
            self.content = content
        }
        
        func layout(bounds: Rect) -> Size {
            if self.barHidden == false {
                let barSize = self.bar.size(available: Size(
                    width: bounds.width,
                    height: .infinity
                ))
                self.bar.frame = Rect(
                    x: bounds.x,
                    y: bounds.y,
                    width: bounds.width,
                    height: self.barOffset + (barSize.height * self.barVisibility)
                )
                self.barSize = barSize.height
            }
            self.content.frame = bounds
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            return self.content.size(available: available)
        }
        
        func views(bounds: Rect) -> [IUIView] {
            var views: [IUIView] = [ self.content ]
            if self.barHidden == false {
                views.append(self.bar)
            }
            return views
        }
        
    }
    
}
