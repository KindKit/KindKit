//
//  KindKit
//

import Foundation

public extension UI.DragAndDrop {
    
    struct DragSession {
        
#if os(iOS)
        
        public let native: UIDragSession
        public let target: NativeView
        
        public init(
            _ native: UIDragSession,
            _ target: UIView
        ) {
            self.native = native
            self.target = target
        }
        
#endif
        
    }
    
}

#if os(macOS)
#elseif os(iOS)

public extension UI.DragAndDrop.DragSession {
    
    var location: Point {
        return .init(self.native.location(in: self.target))
    }
    
    var dragItems: [UIDragItem] {
        return self.native.items
    }
    
    var itemProviders: [NSItemProvider] {
        return self.dragItems.map({ $0.itemProvider })
    }
    
    func location(in view: IUIView) -> Point {
        return .init(self.native.location(in: view.native))
    }
    
    func canLoad(ofClass aClass: NSItemProviderReading.Type) -> Bool {
        return self.itemProviders.contains(where: { $0.canLoadObject(ofClass: aClass) })
    }
    
}

#endif
