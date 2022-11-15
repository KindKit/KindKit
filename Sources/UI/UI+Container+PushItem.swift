//
//  KindKit
//

import Foundation

extension UI.Container {
    
    final class PushItem {
        
        var container: IUIPushContentContainer
        var view: IUIView
        var viewItem: UI.Layout.Item
        var viewSize: SizeFloat
        
        init(
            _ container: IUIPushContentContainer,
            _ available: SizeFloat,
            _ parentInset: InsetFloat,
            _ contentInset: InsetFloat
        ) {
            self.container = container
            self.view = container.view
            self.viewItem = UI.Layout.Item(container.view)
            if container.pushOptions.contains(.useContentInset) == true {
                self.viewSize = container.view.size(available: available.inset(contentInset))
            } else {
                self.viewSize = container.view.size(available: available.inset(parentInset))
            }
        }
        
        func update(
            _ available: SizeFloat,
            _ parentInset: InsetFloat,
            _ contentInset: InsetFloat
        ) {
            if self.container.pushOptions.contains(.useContentInset) == true {
                self.viewSize = self.container.view.size(available: available.inset(contentInset))
            } else {
                self.viewSize = self.container.view.size(available: available.inset(parentInset))
            }
        }
        
    }
    
}

extension UI.Container.PushItem : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension UI.Container.PushItem : Equatable {
    
    static func == (lhs: UI.Container.PushItem, rhs: UI.Container.PushItem) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}
