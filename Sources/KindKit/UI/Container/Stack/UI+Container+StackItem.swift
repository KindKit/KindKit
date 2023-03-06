//
//  KindKit
//

import Foundation

extension UI.Container {
    
    final class StackItem {
        
        var container: IUIStackContentContainer
        var owner: AnyObject?
        var view: IUIView
        var bar: IUIView {
            set { self._layout.bar = newValue }
            get { self._layout.bar }
        }
        var barVisibility: Double {
            set { self._layout.barVisibility = newValue }
            get { self._layout.barVisibility }
        }
        var barHidden: Bool {
            set { self._layout.barHidden = newValue }
            get { self._layout.barHidden }
        }
        var barSize: Double {
            return self._layout.barSize
        }
        
        private var _layout: Layout
        
        init(
            _ container: IUIStackContentContainer,
            _ owner: AnyObject? = nil,
            inset: Inset = .zero
        ) {
            container.stackBar.safeArea(Inset(top: 0, left: inset.left, right: inset.right, bottom: 0))
            self._layout = Layout(
                bar: container.stackBar,
                barVisibility: container.stackBarVisibility,
                barHidden: container.stackBarHidden,
                barOffset: inset.top,
                content: container.view
            )
            self.container = container
            self.owner = owner
            self.view = UI.View.Custom().content(self._layout)
        }
        
        func set(inset: Inset) {
            self.container.stackBar.safeArea(Inset(top: 0, left: inset.left, right: inset.right, bottom: 0))
            self._layout.barOffset = inset.top
        }
        
        func update() {
            self._layout.bar = self.container.stackBar
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

