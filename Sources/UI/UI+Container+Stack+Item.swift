//
//  KindKit
//

import Foundation

extension UI.Container.Stack {
    
    final class Item {
        
        var container: IUIStackContentContainer
        var owner: AnyObject?
        var view: IUIView {
            return self.item.view
        }
        var item: UI.Layout.Item
        var bar: UI.Layout.Item {
            set(value) { self._layout.bar = value }
            get { return self._layout.bar }
        }
        var barVisibility: Float {
            set(value) { self._layout.barVisibility = value }
            get { return self._layout.barVisibility }
        }
        var barHidden: Bool {
            set(value) { self._layout.barHidden = value }
            get { return self._layout.barHidden }
        }
        var barSize: Float {
            return self._layout.barSize
        }
        
        private var _layout: Layout
        
        init(
            container: IUIStackContentContainer,
            owner: AnyObject? = nil,
            insets: InsetFloat
        ) {
            container.stackBar.safeArea(InsetFloat(top: 0, left: insets.left, right: insets.right, bottom: 0))
            self._layout = Layout(
                bar: UI.Layout.Item(container.stackBar),
                barVisibility: container.stackBarVisibility,
                barHidden: container.stackBarHidden,
                barOffset: insets.top,
                content: UI.Layout.Item(container.view)
            )
            self.container = container
            self.owner = owner
            self.item = UI.Layout.Item(UI.View.Custom(self._layout))
        }
        
        func set(insets: InsetFloat) {
            self.container.stackBar.safeArea(InsetFloat(top: 0, left: insets.left, right: insets.right, bottom: 0))
            self._layout.barOffset = insets.top
        }
        
        func update() {
            if self.container.stackBar !== self._layout.bar.view {
                self._layout.bar = UI.Layout.Item(self.container.stackBar)
            }
            self._layout.barVisibility = self.container.stackBarVisibility
            self._layout.barHidden = self.container.stackBarHidden
        }
        
    }
    
}
