//
//  KindKit
//

import Foundation

public extension UI.DragAndDrop {
    
    struct DropSession {
        
#if os(iOS)
        
        public let native: UIDropSession
        public let target: NativeView
        
        public init(
            _ native: UIDropSession,
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

public extension UI.DragAndDrop.DropSession {
    
    var location: Point {
        return .init(self.native.location(in: self.target))
    }
    
    var itemProviders: [NSItemProvider] {
        return self.native.items.map({ $0.itemProvider })
    }
    
    func canLoad(ofClass aClass: NSItemProviderReading.Type) -> Bool {
        return self.native.items.contains(where: { $0.itemProvider.canLoadObject(ofClass: aClass) })
    }
    
}

#endif
