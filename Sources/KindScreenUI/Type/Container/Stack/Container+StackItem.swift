//
//  KindKit
//

import KindUI

extension Container {
    
    final class StackItem {
        
        var container: IStackContentContainer
        var owner: AnyObject?
        var view: IView
        var bar: IView {
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
            _ container: IStackContentContainer,
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
            self.view = CustomView().content(self._layout)
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

extension Container.StackItem : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension Container.StackItem : Equatable {
    
    static func == (lhs: Container.StackItem, rhs: Container.StackItem) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}

