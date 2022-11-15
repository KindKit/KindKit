//
//  KindKit
//

import Foundation

extension UI.Container {
    
    final class StackItem {
        
        var container: IUIStackContentContainer
        var owner: AnyObject?
        var view: IUIView
        var viewItem: UI.Layout.Item
        var barItem: UI.Layout.Item {
            set { self._layout.bar = newValue }
            get { self._layout.bar }
        }
        var barVisibility: Float {
            set { self._layout.barVisibility = newValue }
            get { self._layout.barVisibility }
        }
        var barHidden: Bool {
            set { self._layout.barHidden = newValue }
            get { self._layout.barHidden }
        }
        var barSize: Float {
            return self._layout.barSize
        }
        
        private var _layout: Layout
        
        init(
            _ container: IUIStackContentContainer,
            _ owner: AnyObject? = nil,
            inset: InsetFloat = .zero
        ) {
            container.stackBar.safeArea(InsetFloat(top: 0, left: inset.left, right: inset.right, bottom: 0))
            self._layout = Layout(
                bar: UI.Layout.Item(container.stackBar),
                barVisibility: container.stackBarVisibility,
                barHidden: container.stackBarHidden,
                barOffset: inset.top,
                content: UI.Layout.Item(container.view)
            )
            self.container = container
            self.owner = owner
            self.view = UI.View.Custom().content(self._layout)
            self.viewItem = UI.Layout.Item(self.view)
        }
        
        func set(inset: InsetFloat) {
            self.container.stackBar.safeArea(InsetFloat(top: 0, left: inset.left, right: inset.right, bottom: 0))
            self._layout.barOffset = inset.top
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

extension UI.Container.StackItem : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension UI.Container.StackItem : Equatable {
    
    static func == (lhs: UI.Container.StackItem, rhs: UI.Container.StackItem) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}

