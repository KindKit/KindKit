//
//  KindKit
//

import KindGeometry

final class ElementCache {
    
    private var _map: [Key : Size] = [:]
    
    init() {
    }
    
    func sizeOf(_ request: SizeRequest, content: (SizeRequest) -> Size) -> Size {
        let key = Key(
            container: request.container,
            available: request.available
        )
        if let size = self._map[key] {
            return size
        }
        let size = content(request)
        if size.isValid {
            self._map[key] = size
        }
        return size
    }
    
    func reset() {
        self._map.removeAll(keepingCapacity: true)
    }
    
}

extension ElementCache {
    
    struct Key : Hashable {
        
        let container: Size
        let available: Size
        
    }
    
}

extension ElementCache {
    
    @inline(__always)
    func sizeOf(_ request: SizeRequest, content: any Layout) -> Size {
        return self.sizeOf(request, content: { content.sizeOf($0) })
    }
    
    @inline(__always)
    func sizeOf(_ request: ArrangeRequest, content: any Layout) -> Size {
        return self.sizeOf(.init(request), content: { content.sizeOf($0) })
    }
    
    @inline(__always)
    func size< Layout : KindLayout.Layout >(of request: SizeRequest, content: Layout) -> Size {
        return self.sizeOf(request, content: { content.sizeOf($0) })
    }
    
    @inline(__always)
    func size< Layout : KindLayout.Layout >(of request: ArrangeRequest, content: Layout) -> Size {
        return self.sizeOf(.init(request), content: { content.sizeOf($0) })
    }
    
}

extension ElementCache {
    
    @inline(__always)
    func sizeOf(_ request: SizeRequest, content: any Item) -> Size {
        return self.sizeOf(request, content: { content.sizeOf($0) })
    }
    
    @inline(__always)
    func sizeOf(_ request: ArrangeRequest, content: any Item) -> Size {
        return self.sizeOf(.init(request), content: { content.sizeOf($0) })
    }
    
    @inline(__always)
    func size< Item : KindLayout.Item >(of request: SizeRequest, content: Item) -> Size {
        return self.sizeOf(request, content: { content.sizeOf($0) })
    }
    
    @inline(__always)
    func size< Item : KindLayout.Item >(of request: ArrangeRequest, content: Item) -> Size {
        return self.sizeOf(.init(request), content: { content.sizeOf($0) })
    }
    
}
