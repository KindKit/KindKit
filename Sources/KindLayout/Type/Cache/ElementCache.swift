//
//  KindKit
//

import KindMath

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
        if size.width.isInfinite == false && size.height.isInfinite == false {
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
    func sizeOf(_ request: SizeRequest, content: ILayout) -> Size {
        return self.sizeOf(request, content: { content.sizeOf($0) })
    }
    
    @inline(__always)
    func sizeOf(_ request: ArrangeRequest, content: ILayout) -> Size {
        return self.sizeOf(.init(request), content: { content.sizeOf($0) })
    }
    
    @inline(__always)
    func size< LayoutType : ILayout >(of request: SizeRequest, content: LayoutType) -> Size {
        return self.sizeOf(request, content: { content.sizeOf($0) })
    }
    
    @inline(__always)
    func size< LayoutType : ILayout >(of request: ArrangeRequest, content: LayoutType) -> Size {
        return self.sizeOf(.init(request), content: { content.sizeOf($0) })
    }
    
}

extension ElementCache {
    
    @inline(__always)
    func sizeOf(_ request: SizeRequest, content: IItem) -> Size {
        return self.sizeOf(request, content: { content.sizeOf($0) })
    }
    
    @inline(__always)
    func sizeOf(_ request: ArrangeRequest, content: IItem) -> Size {
        return self.sizeOf(.init(request), content: { content.sizeOf($0) })
    }
    
    @inline(__always)
    func size< ItemType : IItem >(of request: SizeRequest, content: ItemType) -> Size {
        return self.sizeOf(request, content: { content.sizeOf($0) })
    }
    
    @inline(__always)
    func size< ItemType : IItem >(of request: ArrangeRequest, content: ItemType) -> Size {
        return self.sizeOf(.init(request), content: { content.sizeOf($0) })
    }
    
}
