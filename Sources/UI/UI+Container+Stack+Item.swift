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
        var barSize: Float {
            return self._layout.barSize
        }
        var barVisibility: Float {
            set(value) { self._layout.barVisibility = value }
            get { return self._layout.barVisibility }
        }
        var barHidden: Bool {
            set(value) { self._layout.barHidden = value }
            get { return self._layout.barHidden }
        }
        var barItem: UI.Layout.Item {
            set(value) { self._layout.barItem = value }
            get { return self._layout.barItem }
        }
        
        private var _layout: Layout
        
        init(
            container: IUIStackContentContainer,
            owner: AnyObject? = nil,
            insets: InsetFloat
        ) {
            container.stackBarView.safeArea(InsetFloat(top: 0, left: insets.left, right: insets.right, bottom: 0))
            self._layout = Layout(
                barOffset: insets.top,
                barVisibility: container.stackBarVisibility,
                barHidden: container.stackBarHidden,
                barItem: UI.Layout.Item(container.stackBarView),
                contentItem: UI.Layout.Item(container.view)
            )
            self.container = container
            self.owner = owner
            self.item = UI.Layout.Item(UI.View.Custom(self._layout))
        }
        
        func set(insets: InsetFloat) {
            self.container.stackBarView.safeArea(InsetFloat(top: 0, left: insets.left, right: insets.right, bottom: 0))
            self._layout.barOffset = insets.top
        }
        
        func update() {
            if self.container.stackBarView !== self._layout.barItem.view {
                self._layout.barItem = UI.Layout.Item(self.container.stackBarView)
            }
            self._layout.barVisibility = self.container.stackBarVisibility
            self._layout.barHidden = self.container.stackBarHidden
        }
        
    }
    
}
