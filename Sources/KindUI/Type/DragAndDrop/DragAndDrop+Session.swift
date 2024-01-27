//
//  KindKit
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindMath

public extension DragAndDrop {
    
    struct Session {
        
        public let location: Point
#if os(macOS)
        public let items: [NSPasteboardItem]
#elseif os(iOS)
        public let items: [NSItemProvider]
#endif
        
#if os(iOS)
        
        public init(
            _ session: UIDropSession,
            _ view: UIView
        ) {
            self.location = .init(session.location(in: view))
            self.items = session.items.map({ $0.itemProvider })
        }
        
#endif
        
    }
    
}

#if os(macOS)
#elseif os(iOS)

public extension DragAndDrop.Session {
    
    func canLoad(ofClass aClass: NSItemProviderReading.Type) -> Bool {
        return self.items.contains(where: { $0.canLoadObject(ofClass: aClass) })
    }
    
}

#endif
